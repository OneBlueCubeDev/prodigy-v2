#!/bin/bash
#
# Prodigy Development Server Management Script
#
# SYNOPSIS
#   Starts or stops the Next.js development server.
#
# USAGE
#   ./scripts/dev-server.sh start              # Start in foreground
#   ./scripts/dev-server.sh start --background # Start in background
#   ./scripts/dev-server.sh stop               # Stop the server
#   ./scripts/dev-server.sh restart            # Restart in foreground
#   ./scripts/dev-server.sh restart --background # Restart in background
#   ./scripts/dev-server.sh status             # Check server status
#

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$PROJECT_DIR/logs"
PID_FILE="$SCRIPT_DIR/.dev-server.pid"
LOG_FILE="$LOGS_DIR/dev-server.log"
SERVER_PORT=3040

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Parse arguments
COMMAND="${1:-start}"
BACKGROUND=false

shift || true
while [[ $# -gt 0 ]]; do
    case "$1" in
        --background|-b)
            BACKGROUND=true
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Ensure logs directory exists
mkdir -p "$LOGS_DIR"

# Get PID of process listening on a port
get_port_pid() {
    local port=$1
    local pid=""

    # Try lsof first (macOS + Linux)
    if command -v lsof &> /dev/null; then
        pid=$(lsof -ti ":$port" 2>/dev/null | head -1)
        if [[ -n "$pid" ]]; then
            echo "$pid"
            return
        fi
    fi

    # Try ss (modern Linux)
    if command -v ss &> /dev/null; then
        pid=$(ss -tlnp "sport = :$port" 2>/dev/null | grep -oP 'pid=\K\d+' | head -1)
        if [[ -n "$pid" ]]; then
            echo "$pid"
            return
        fi
    fi

    # Try netstat as last resort
    if command -v netstat &> /dev/null; then
        pid=$(netstat -tlnp 2>/dev/null | grep ":$port " | awk '{print $7}' | cut -d'/' -f1 | head -1)
        if [[ -n "$pid" ]]; then
            echo "$pid"
            return
        fi
    fi
}

# Kill process on a specific port
kill_port_process() {
    local port=$1
    local pid
    pid=$(get_port_pid "$port")

    if [[ -n "$pid" ]]; then
        echo -e "${YELLOW}Killing process (PID: $pid) on port $port...${NC}"
        kill -9 "$pid" 2>/dev/null || true
        sleep 0.5
    fi
}

# Check if a process is running
is_process_running() {
    local pid=$1
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
        return 0
    fi
    return 1
}

# Get server status
get_server_status() {
    # Check if process from PID file is running
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid=$(cat "$PID_FILE")
        if is_process_running "$pid"; then
            echo "running:$pid:pidfile"
            return
        fi
    fi

    # Check if something is listening on the port
    local port_pid
    port_pid=$(get_port_pid "$SERVER_PORT")
    if [[ -n "$port_pid" ]]; then
        echo "running:$port_pid:port"
        return
    fi

    echo "stopped::"
}

# Start the server
start_server() {
    local status
    status=$(get_server_status)
    local state="${status%%:*}"
    local pid="${status#*:}"
    pid="${pid%%:*}"

    if [[ "$state" == "running" ]]; then
        echo -e "${YELLOW}Server is already running (PID: $pid).${NC}"
        return
    fi

    # Kill any existing process on the server port (in case of zombie)
    kill_port_process "$SERVER_PORT"

    if [[ ! -d "$PROJECT_DIR" ]]; then
        echo -e "${RED}Project directory not found: $PROJECT_DIR${NC}"
        return 1
    fi

    cd "$PROJECT_DIR"

    if [[ "$BACKGROUND" == true ]]; then
        echo -e "${CYAN}Starting dev server in background...${NC}"

        if command -v setsid &> /dev/null; then
            setsid env PORT=$SERVER_PORT pnpm dev >> "$LOG_FILE" 2>&1 &
        else
            nohup env PORT=$SERVER_PORT pnpm dev >> "$LOG_FILE" 2>&1 &
            disown
        fi
        local cmd_pid=$!

        echo -e "${GRAY}Waiting for server to start...${NC}"
        local max_wait=15
        local waited=0
        local node_pid=""

        while [[ $waited -lt $max_wait ]]; do
            sleep 1
            waited=$((waited + 1))

            node_pid=$(get_port_pid "$SERVER_PORT")
            if [[ -n "$node_pid" ]]; then
                break
            fi

            echo -n "."
        done
        echo ""

        if [[ -n "$node_pid" ]]; then
            echo "$node_pid" > "$PID_FILE"
            echo -e "${GREEN}Server started in background (PID: $node_pid).${NC}"
            echo -e "${CYAN}URL: http://localhost:$SERVER_PORT${NC}"
            echo -e "${GRAY}Log file: $LOG_FILE${NC}"
            echo -e "${GRAY}Use './scripts/dev-server.sh stop' to stop the server.${NC}"
        else
            echo -e "${YELLOW}Server may still be starting. Check status with './scripts/dev-server.sh status'${NC}"
            echo -e "${GRAY}Log file: $LOG_FILE${NC}"
        fi
    else
        echo -e "${CYAN}Starting development server...${NC}"
        echo -e "${CYAN}URL: http://localhost:$SERVER_PORT${NC}"
        echo -e "${GRAY}Project directory: $PROJECT_DIR${NC}"
        echo -e "${GRAY}Press Ctrl+C to stop the server.${NC}"
        echo ""

        echo "$$" > "$PID_FILE"

        cleanup() {
            rm -f "$PID_FILE"
            exit 0
        }
        trap cleanup EXIT INT TERM

        PORT=$SERVER_PORT pnpm dev
    fi
}

# Stop the server
stop_server() {
    local status
    status=$(get_server_status)
    local state="${status%%:*}"
    local pid="${status#*:}"
    pid="${pid%%:*}"

    if [[ "$state" != "running" ]]; then
        echo -e "${YELLOW}Server is not running.${NC}"
        rm -f "$PID_FILE"
        return
    fi

    echo -e "${CYAN}Stopping server (PID: $pid)...${NC}"

    if command -v pkill &> /dev/null; then
        pkill -P "$pid" 2>/dev/null || true
    fi

    if kill -15 "$pid" 2>/dev/null; then
        sleep 1
        if is_process_running "$pid"; then
            kill -9 "$pid" 2>/dev/null || true
        fi
    fi

    rm -f "$PID_FILE"
    echo -e "${GREEN}Server stopped.${NC}"
}

# Show server status
show_status() {
    local status
    status=$(get_server_status)
    local state="${status%%:*}"
    local pid="${status#*:}"
    pid="${pid%%:*}"

    if [[ "$state" == "running" ]]; then
        echo -e "${GREEN}Dev server is RUNNING (PID: $pid)${NC}"
        echo -e "${CYAN}URL: http://localhost:$SERVER_PORT${NC}"
    else
        echo -e "${RED}Dev server is STOPPED${NC}"
    fi
}

# Show usage
show_usage() {
    echo -e "${YELLOW}Usage: ./scripts/dev-server.sh [start|stop|restart|status] [--background|-b]${NC}"
    echo -e "${GRAY}Default command is 'start'${NC}"
    echo ""
    echo "Commands:"
    echo "  start    Start the development server (foreground by default)"
    echo "  stop     Stop the running server"
    echo "  restart  Restart the server"
    echo "  status   Show server status"
    echo ""
    echo "Options:"
    echo "  --background, -b  Run the server in background mode"
}

# Main command dispatcher
case "$COMMAND" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    restart)
        stop_server
        sleep 2
        start_server
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        echo -e "${RED}Invalid command: $COMMAND${NC}"
        show_usage
        exit 1
        ;;
esac
