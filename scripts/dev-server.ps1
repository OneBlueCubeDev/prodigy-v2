<#
.SYNOPSIS
    Prodigy Development Server Management Script

.DESCRIPTION
    Starts or stops the Next.js development server.

.USAGE
    .\scripts\dev-server.ps1 start              # Start in foreground
    .\scripts\dev-server.ps1 start -Background  # Start in background
    .\scripts\dev-server.ps1 stop               # Stop the server
    .\scripts\dev-server.ps1 restart            # Restart in foreground
    .\scripts\dev-server.ps1 restart -Background # Restart in background
    .\scripts\dev-server.ps1 status             # Check server status
#>

param(
    [Parameter(Position = 0)]
    [ValidateSet("start", "stop", "restart", "status", "help")]
    [string]$Command = "start",

    [Alias("b")]
    [switch]$Background
)

# Configuration
$ScriptDir = $PSScriptRoot
$ProjectDir = Split-Path $ScriptDir -Parent
$LogsDir = Join-Path $ProjectDir "logs"
$PidFile = Join-Path $ScriptDir ".dev-server.pid"
$LogFile = Join-Path $LogsDir "dev-server.log"
$ServerPort = 3000

# Ensure logs directory exists
if (-not (Test-Path $LogsDir)) {
    New-Item -ItemType Directory -Path $LogsDir -Force | Out-Null
}

function Get-PortPid {
    param([int]$Port)
    $connection = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($connection) {
        return $connection.OwningProcess
    }
    return $null
}

function Test-ProcessRunning {
    param([int]$Pid)
    if ($Pid -and (Get-Process -Id $Pid -ErrorAction SilentlyContinue)) {
        return $true
    }
    return $false
}

function Get-ServerStatus {
    # Check PID file first
    if (Test-Path $PidFile) {
        $pid = [int](Get-Content $PidFile -ErrorAction SilentlyContinue)
        if ($pid -and (Test-ProcessRunning -Pid $pid)) {
            return @{ State = "running"; Pid = $pid; Source = "pidfile" }
        }
    }

    # Check port
    $portPid = Get-PortPid -Port $ServerPort
    if ($portPid) {
        return @{ State = "running"; Pid = $portPid; Source = "port" }
    }

    return @{ State = "stopped"; Pid = $null; Source = $null }
}

function Stop-PortProcess {
    param([int]$Port)
    $pid = Get-PortPid -Port $Port
    if ($pid) {
        Write-Host "Killing process (PID: $pid) on port $Port..." -ForegroundColor Yellow
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }
}

function Start-Server {
    $status = Get-ServerStatus

    if ($status.State -eq "running") {
        Write-Host "Server is already running (PID: $($status.Pid))." -ForegroundColor Yellow
        return
    }

    # Kill any zombie process on the port
    Stop-PortProcess -Port $ServerPort

    if (-not (Test-Path $ProjectDir)) {
        Write-Host "Project directory not found: $ProjectDir" -ForegroundColor Red
        return
    }

    Push-Location $ProjectDir

    try {
        if ($Background) {
            Write-Host "Starting dev server in background..." -ForegroundColor Cyan

            $job = Start-Process -FilePath "pnpm" -ArgumentList "dev" `
                -WorkingDirectory $ProjectDir `
                -RedirectStandardOutput $LogFile `
                -RedirectStandardError (Join-Path $LogsDir "dev-server-error.log") `
                -PassThru -WindowStyle Hidden `
                -Environment @{ PORT = $ServerPort }

            Write-Host "Waiting for server to start..." -ForegroundColor DarkGray
            $maxWait = 15
            $waited = 0
            $nodePid = $null

            while ($waited -lt $maxWait) {
                Start-Sleep -Seconds 1
                $waited++

                $nodePid = Get-PortPid -Port $ServerPort
                if ($nodePid) { break }

                Write-Host "." -NoNewline
            }
            Write-Host ""

            if ($nodePid) {
                $nodePid | Out-File -FilePath $PidFile -NoNewline
                Write-Host "Server started in background (PID: $nodePid)." -ForegroundColor Green
                Write-Host "URL: http://localhost:$ServerPort" -ForegroundColor Cyan
                Write-Host "Log file: $LogFile" -ForegroundColor DarkGray
                Write-Host "Use '.\scripts\dev-server.ps1 stop' to stop the server." -ForegroundColor DarkGray
            }
            else {
                Write-Host "Server may still be starting. Check status with '.\scripts\dev-server.ps1 status'" -ForegroundColor Yellow
                Write-Host "Log file: $LogFile" -ForegroundColor DarkGray
            }
        }
        else {
            Write-Host "Starting development server..." -ForegroundColor Cyan
            Write-Host "URL: http://localhost:$ServerPort" -ForegroundColor Cyan
            Write-Host "Project directory: $ProjectDir" -ForegroundColor DarkGray
            Write-Host "Press Ctrl+C to stop the server." -ForegroundColor DarkGray
            Write-Host ""

            $PID | Out-File -FilePath $PidFile -NoNewline

            try {
                $env:PORT = $ServerPort
                pnpm dev
            }
            finally {
                Remove-Item -Path $PidFile -Force -ErrorAction SilentlyContinue
            }
        }
    }
    finally {
        Pop-Location
    }
}

function Stop-Server {
    $status = Get-ServerStatus

    if ($status.State -ne "running") {
        Write-Host "Server is not running." -ForegroundColor Yellow
        Remove-Item -Path $PidFile -Force -ErrorAction SilentlyContinue
        return
    }

    Write-Host "Stopping server (PID: $($status.Pid))..." -ForegroundColor Cyan

    # Kill child processes first
    Get-CimInstance Win32_Process -Filter "ParentProcessId = $($status.Pid)" -ErrorAction SilentlyContinue |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }

    # Kill main process
    Stop-Process -Id $status.Pid -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1

    Remove-Item -Path $PidFile -Force -ErrorAction SilentlyContinue
    Write-Host "Server stopped." -ForegroundColor Green
}

function Show-Status {
    $status = Get-ServerStatus

    if ($status.State -eq "running") {
        Write-Host "Dev server is RUNNING (PID: $($status.Pid))" -ForegroundColor Green
        Write-Host "URL: http://localhost:$ServerPort" -ForegroundColor Cyan
    }
    else {
        Write-Host "Dev server is STOPPED" -ForegroundColor Red
    }
}

function Show-Usage {
    Write-Host "Usage: .\scripts\dev-server.ps1 [start|stop|restart|status] [-Background|-b]" -ForegroundColor Yellow
    Write-Host "Default command is 'start'" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  start    Start the development server (foreground by default)"
    Write-Host "  stop     Stop the running server"
    Write-Host "  restart  Restart the server"
    Write-Host "  status   Show server status"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Background, -b  Run the server in background mode"
}

# Main command dispatcher
switch ($Command) {
    "start"   { Start-Server }
    "stop"    { Stop-Server }
    "restart" {
        Stop-Server
        Start-Sleep -Seconds 2
        Start-Server
    }
    "status"  { Show-Status }
    "help"    { Show-Usage }
}
