#!/bin/bash
#
# Prodigy Development Server Management Script
#
# SYNOPSIS
#   Starts or stops the Next.js development server and PostgreSQL database.
#
# USAGE
#   ./scripts/dev-server.sh start              # Start DB + server in foreground
#   ./scripts/dev-server.sh start --background # Start DB + server in background
#   ./scripts/dev-server.sh stop               # Stop the server (DB keeps running)
#   ./scripts/dev-server.sh stop --all         # Stop server + DB
#   ./scripts/dev-server.sh restart            # Restart in foreground
#   ./scripts/dev-server.sh restart --background # Restart in background
#   ./scripts/dev-server.sh status             # Check server + DB status
#   ./scripts/dev-server.sh db start           # Start DB only
#   ./scripts/dev-server.sh db stop            # Stop DB only
#   ./scripts/dev-server.sh db reset           # Drop and recreate DB + reseed
#

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$PROJECT_DIR/logs"
PID_FILE="$SCRIPT_DIR/.dev-server.pid"
LOG_FILE="$LOGS_DIR/dev-server.log"
SERVER_PORT=3040

# Docker PostgreSQL config
DB_CONTAINER="prodigy-pg"
DB_PORT=5432
DB_USER="postgres"
DB_PASSWORD="dev"
DB_NAME="prodigy"

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
STOP_ALL=false

shift || true
while [[ $# -gt 0 ]]; do
    case "$1" in
        --background|-b)
            BACKGROUND=true
            shift
            ;;
        --all|-a)
            STOP_ALL=true
            shift
            ;;
        start|stop|reset|status)
            # Sub-command for db
            DB_SUBCMD="$1"
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

# ─── Database Functions ───────────────────────────────────────────────

is_docker_available() {
    command -v docker &> /dev/null && docker info &> /dev/null
}

is_db_container_running() {
    docker container inspect -f '{{.State.Running}}' "$DB_CONTAINER" 2>/dev/null | grep -q "true"
}

is_db_container_exists() {
    docker container inspect "$DB_CONTAINER" &>/dev/null
}

wait_for_db() {
    local max_wait=10
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if docker exec "$DB_CONTAINER" pg_isready -U "$DB_USER" &>/dev/null; then
            return 0
        fi
        sleep 1
        waited=$((waited + 1))
        echo -n "."
    done
    echo ""
    return 1
}

db_exists() {
    docker exec "$DB_CONTAINER" psql -U "$DB_USER" -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw "$DB_NAME"
}

start_db() {
    if ! is_docker_available; then
        echo -e "${RED}Docker is not available. Install Docker or start Docker Desktop.${NC}"
        return 1
    fi

    if is_db_container_running; then
        echo -e "${GREEN}PostgreSQL is already running (container: $DB_CONTAINER).${NC}"
    elif is_db_container_exists; then
        echo -e "${CYAN}Starting existing PostgreSQL container...${NC}"
        docker start "$DB_CONTAINER" > /dev/null
        echo -n -e "${GRAY}Waiting for PostgreSQL"
        if wait_for_db; then
            echo -e "${GREEN} ready.${NC}"
        else
            echo -e "${RED} failed to start.${NC}"
            return 1
        fi
    else
        echo -e "${CYAN}Creating PostgreSQL container...${NC}"
        docker run --name "$DB_CONTAINER" \
            -e POSTGRES_PASSWORD="$DB_PASSWORD" \
            -p "$DB_PORT:5432" \
            -d postgres:15 > /dev/null
        echo -n -e "${GRAY}Waiting for PostgreSQL"
        if wait_for_db; then
            echo -e "${GREEN} ready.${NC}"
        else
            echo -e "${RED} failed to start.${NC}"
            return 1
        fi
    fi

    # Create database if it doesn't exist
    if ! db_exists; then
        echo -e "${CYAN}Creating database '$DB_NAME'...${NC}"
        docker exec "$DB_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;" > /dev/null 2>&1
        echo -e "${GREEN}Database created.${NC}"

        # Push schema and seed
        echo -e "${CYAN}Pushing Prisma schema...${NC}"
        cd "$PROJECT_DIR"
        pnpm prisma db push --skip-generate > /dev/null 2>&1
        pnpm prisma generate > /dev/null 2>&1
        echo -e "${GREEN}Schema pushed.${NC}"

        echo -e "${CYAN}Seeding database...${NC}"
        pnpm prisma db seed 2>&1 | tail -1
        echo -e "${GREEN}Database seeded.${NC}"
    fi
}

stop_db() {
    if is_db_container_running; then
        echo -e "${CYAN}Stopping PostgreSQL container...${NC}"
        docker stop "$DB_CONTAINER" > /dev/null
        echo -e "${GREEN}PostgreSQL stopped.${NC}"
    else
        echo -e "${YELLOW}PostgreSQL is not running.${NC}"
    fi
}

reset_db() {
    if ! is_db_container_running; then
        echo -e "${RED}PostgreSQL is not running. Start it first.${NC}"
        return 1
    fi

    echo -e "${YELLOW}Dropping database '$DB_NAME'...${NC}"
    docker exec "$DB_CONTAINER" psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;" > /dev/null 2>&1
    docker exec "$DB_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;" > /dev/null 2>&1
    echo -e "${GREEN}Database recreated.${NC}"

    cd "$PROJECT_DIR"
    echo -e "${CYAN}Pushing Prisma schema...${NC}"
    pnpm prisma db push --skip-generate > /dev/null 2>&1
    pnpm prisma generate > /dev/null 2>&1
    echo -e "${CYAN}Seeding database...${NC}"
    pnpm prisma db seed 2>&1 | tail -1
    echo -e "${GREEN}Database reset complete.${NC}"
}

show_db_status() {
    if ! is_docker_available; then
        echo -e "${RED}PostgreSQL: Docker not available${NC}"
        return
    fi
    if is_db_container_running; then
        echo -e "${GREEN}PostgreSQL is RUNNING (container: $DB_CONTAINER, port: $DB_PORT)${NC}"
        if db_exists; then
            echo -e "${GREEN}Database '$DB_NAME' exists${NC}"
        else
            echo -e "${YELLOW}Database '$DB_NAME' does not exist${NC}"
        fi
    else
        echo -e "${RED}PostgreSQL is STOPPED${NC}"
    fi
}

# ─── Server Functions ─────────────────────────────────────────────────

get_port_pid() {
    local port=$1
    local pid=""

    if command -v lsof &> /dev/null; then
        pid=$(lsof -ti ":$port" 2>/dev/null | head -1)
        if [[ -n "$pid" ]]; then
            echo "$pid"
            return
        fi
    fi

    if command -v ss &> /dev/null; then
        pid=$(ss -tlnp "sport = :$port" 2>/dev/null | grep -oP 'pid=\K\d+' | head -1)
        if [[ -n "$pid" ]]; then
            echo "$pid"
            return
        fi
    fi

    if command -v netstat &> /dev/null; then
        pid=$(netstat -tlnp 2>/dev/null | grep ":$port " | awk '{print $7}' | cut -d'/' -f1 | head -1)
        if [[ -n "$pid" ]]; then
            echo "$pid"
            return
        fi
    fi
}

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

is_process_running() {
    local pid=$1
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
        return 0
    fi
    return 1
}

get_server_status() {
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid=$(cat "$PID_FILE")
        if is_process_running "$pid"; then
            echo "running:$pid:pidfile"
            return
        fi
    fi

    local port_pid
    port_pid=$(get_port_pid "$SERVER_PORT")
    if [[ -n "$port_pid" ]]; then
        echo "running:$port_pid:port"
        return
    fi

    echo "stopped::"
}

start_server() {
    # Ensure database is running first
    start_db || return 1
    echo ""

    local status
    status=$(get_server_status)
    local state="${status%%:*}"
    local pid="${status#*:}"
    pid="${pid%%:*}"

    if [[ "$state" == "running" ]]; then
        echo -e "${YELLOW}Server is already running (PID: $pid).${NC}"
        return
    fi

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

stop_server() {
    local status
    status=$(get_server_status)
    local state="${status%%:*}"
    local pid="${status#*:}"
    pid="${pid%%:*}"

    if [[ "$state" != "running" ]]; then
        echo -e "${YELLOW}Server is not running.${NC}"
        rm -f "$PID_FILE"
    else
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
    fi

    if [[ "$STOP_ALL" == true ]]; then
        stop_db
    fi
}

show_status() {
    show_db_status
    echo ""

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

show_usage() {
    echo -e "${YELLOW}Usage: ./scripts/dev-server.sh [command] [options]${NC}"
    echo -e "${GRAY}Default command is 'start'${NC}"
    echo ""
    echo "Commands:"
    echo "  start              Start DB + dev server (foreground by default)"
    echo "  stop               Stop the dev server (DB keeps running)"
    echo "  stop --all         Stop dev server + PostgreSQL"
    echo "  restart            Restart the dev server"
    echo "  status             Show server + DB status"
    echo "  db start           Start PostgreSQL only"
    echo "  db stop            Stop PostgreSQL only"
    echo "  db reset           Drop + recreate database and reseed"
    echo "  db status          Show database status"
    echo ""
    echo "Options:"
    echo "  --background, -b   Run the server in background mode"
    echo "  --all, -a          Also stop PostgreSQL (with 'stop' command)"
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
    db)
        case "${DB_SUBCMD:-status}" in
            start)  start_db ;;
            stop)   stop_db ;;
            reset)  reset_db ;;
            status) show_db_status ;;
            *)
                echo -e "${RED}Invalid db command: $DB_SUBCMD${NC}"
                show_usage
                exit 1
                ;;
        esac
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
