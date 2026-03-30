<#
.SYNOPSIS
    Prodigy Development Server Management Script

.DESCRIPTION
    Starts or stops the Next.js development server and PostgreSQL database.

.USAGE
    .\scripts\dev-server.ps1 start              # Start DB + server in foreground
    .\scripts\dev-server.ps1 start -Background  # Start DB + server in background
    .\scripts\dev-server.ps1 stop               # Stop the server (DB keeps running)
    .\scripts\dev-server.ps1 stop -All          # Stop server + DB
    .\scripts\dev-server.ps1 restart            # Restart in foreground
    .\scripts\dev-server.ps1 restart -Background # Restart in background
    .\scripts\dev-server.ps1 status             # Check server + DB status
    .\scripts\dev-server.ps1 db start           # Start DB only
    .\scripts\dev-server.ps1 db stop            # Stop DB only
    .\scripts\dev-server.ps1 db reset           # Drop and recreate DB + reseed
#>

param(
    [Parameter(Position = 0)]
    [ValidateSet("start", "stop", "restart", "status", "db", "help")]
    [string]$Command = "start",

    [Parameter(Position = 1)]
    [string]$SubCommand,

    [Alias("b")]
    [switch]$Background,

    [Alias("a")]
    [switch]$All
)

# Configuration
$ScriptDir = $PSScriptRoot
$ProjectDir = Split-Path $ScriptDir -Parent
$LogsDir = Join-Path $ProjectDir "logs"
$PidFile = Join-Path $ScriptDir ".dev-server.pid"
$LogFile = Join-Path $LogsDir "dev-server.log"
$ServerPort = 3040

# Docker PostgreSQL config
$DbContainer = "prodigy-pg"
$DbPort = 5432
$DbUser = "postgres"
$DbPassword = "dev"
$DbName = "prodigy"

# Ensure logs directory exists
if (-not (Test-Path $LogsDir)) {
    New-Item -ItemType Directory -Path $LogsDir -Force | Out-Null
}

# ─── Database Functions ───────────────────────────────────────────────

function Test-DockerAvailable {
    try {
        $null = & docker info 2>&1
        return $LASTEXITCODE -eq 0
    }
    catch { return $false }
}

function Test-DbContainerRunning {
    $state = & docker container inspect -f '{{.State.Running}}' $DbContainer 2>&1
    return $state -eq "true"
}

function Test-DbContainerExists {
    $null = & docker container inspect $DbContainer 2>&1
    return $LASTEXITCODE -eq 0
}

function Wait-ForDb {
    $maxWait = 10
    $waited = 0
    while ($waited -lt $maxWait) {
        $ready = & docker exec $DbContainer pg_isready -U $DbUser 2>&1
        if ($LASTEXITCODE -eq 0) { return $true }
        Start-Sleep -Seconds 1
        $waited++
        Write-Host "." -NoNewline
    }
    Write-Host ""
    return $false
}

function Test-DbExists {
    $dbs = & docker exec $DbContainer psql -U $DbUser -lqt 2>&1
    return ($dbs | Select-String -Pattern "\b$DbName\b" -Quiet)
}

function Start-Db {
    if (-not (Test-DockerAvailable)) {
        Write-Host "Docker is not available. Install Docker or start Docker Desktop." -ForegroundColor Red
        return $false
    }

    if (Test-DbContainerRunning) {
        Write-Host "PostgreSQL is already running (container: $DbContainer)." -ForegroundColor Green
    }
    elseif (Test-DbContainerExists) {
        Write-Host "Starting existing PostgreSQL container..." -ForegroundColor Cyan
        & docker start $DbContainer | Out-Null
        Write-Host "Waiting for PostgreSQL" -NoNewline -ForegroundColor DarkGray
        if (-not (Wait-ForDb)) {
            Write-Host " failed to start." -ForegroundColor Red
            return $false
        }
        Write-Host " ready." -ForegroundColor Green
    }
    else {
        Write-Host "Creating PostgreSQL container..." -ForegroundColor Cyan
        & docker run --name $DbContainer `
            -e "POSTGRES_PASSWORD=$DbPassword" `
            -p "${DbPort}:5432" `
            -d postgres:15 | Out-Null
        Write-Host "Waiting for PostgreSQL" -NoNewline -ForegroundColor DarkGray
        if (-not (Wait-ForDb)) {
            Write-Host " failed to start." -ForegroundColor Red
            return $false
        }
        Write-Host " ready." -ForegroundColor Green
    }

    # Create database if it doesn't exist
    if (-not (Test-DbExists)) {
        Write-Host "Creating database '$DbName'..." -ForegroundColor Cyan
        & docker exec $DbContainer psql -U $DbUser -c "CREATE DATABASE $DbName;" 2>&1 | Out-Null
        Write-Host "Database created." -ForegroundColor Green

        Push-Location $ProjectDir
        try {
            Write-Host "Pushing Prisma schema..." -ForegroundColor Cyan
            & pnpm prisma db push --skip-generate 2>&1 | Out-Null
            & pnpm prisma generate 2>&1 | Out-Null
            Write-Host "Schema pushed." -ForegroundColor Green

            Write-Host "Seeding database..." -ForegroundColor Cyan
            & pnpm prisma db seed 2>&1 | Select-Object -Last 1
            Write-Host "Database seeded." -ForegroundColor Green
        }
        finally { Pop-Location }
    }

    return $true
}

function Stop-Db {
    if (Test-DbContainerRunning) {
        Write-Host "Stopping PostgreSQL container..." -ForegroundColor Cyan
        & docker stop $DbContainer | Out-Null
        Write-Host "PostgreSQL stopped." -ForegroundColor Green
    }
    else {
        Write-Host "PostgreSQL is not running." -ForegroundColor Yellow
    }
}

function Reset-Db {
    if (-not (Test-DbContainerRunning)) {
        Write-Host "PostgreSQL is not running. Start it first." -ForegroundColor Red
        return
    }

    Write-Host "Dropping database '$DbName'..." -ForegroundColor Yellow
    & docker exec $DbContainer psql -U $DbUser -c "DROP DATABASE IF EXISTS $DbName;" 2>&1 | Out-Null
    & docker exec $DbContainer psql -U $DbUser -c "CREATE DATABASE $DbName;" 2>&1 | Out-Null
    Write-Host "Database recreated." -ForegroundColor Green

    Push-Location $ProjectDir
    try {
        Write-Host "Pushing Prisma schema..." -ForegroundColor Cyan
        & pnpm prisma db push --skip-generate 2>&1 | Out-Null
        & pnpm prisma generate 2>&1 | Out-Null
        Write-Host "Seeding database..." -ForegroundColor Cyan
        & pnpm prisma db seed 2>&1 | Select-Object -Last 1
        Write-Host "Database reset complete." -ForegroundColor Green
    }
    finally { Pop-Location }
}

function Show-DbStatus {
    if (-not (Test-DockerAvailable)) {
        Write-Host "PostgreSQL: Docker not available" -ForegroundColor Red
        return
    }
    if (Test-DbContainerRunning) {
        Write-Host "PostgreSQL is RUNNING (container: $DbContainer, port: $DbPort)" -ForegroundColor Green
        if (Test-DbExists) {
            Write-Host "Database '$DbName' exists" -ForegroundColor Green
        }
        else {
            Write-Host "Database '$DbName' does not exist" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "PostgreSQL is STOPPED" -ForegroundColor Red
    }
}

# ─── Server Functions ─────────────────────────────────────────────────

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
    if (Test-Path $PidFile) {
        $pid = [int](Get-Content $PidFile -ErrorAction SilentlyContinue)
        if ($pid -and (Test-ProcessRunning -Pid $pid)) {
            return @{ State = "running"; Pid = $pid; Source = "pidfile" }
        }
    }

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
    # Ensure database is running first
    if (-not (Start-Db)) { return }
    Write-Host ""

    $status = Get-ServerStatus

    if ($status.State -eq "running") {
        Write-Host "Server is already running (PID: $($status.Pid))." -ForegroundColor Yellow
        return
    }

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
    }
    else {
        Write-Host "Stopping server (PID: $($status.Pid))..." -ForegroundColor Cyan

        Get-CimInstance Win32_Process -Filter "ParentProcessId = $($status.Pid)" -ErrorAction SilentlyContinue |
            ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }

        Stop-Process -Id $status.Pid -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1

        Remove-Item -Path $PidFile -Force -ErrorAction SilentlyContinue
        Write-Host "Server stopped." -ForegroundColor Green
    }

    if ($All) {
        Stop-Db
    }
}

function Show-Status {
    Show-DbStatus
    Write-Host ""

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
    Write-Host "Usage: .\scripts\dev-server.ps1 [command] [options]" -ForegroundColor Yellow
    Write-Host "Default command is 'start'" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  start              Start DB + dev server (foreground by default)"
    Write-Host "  stop               Stop the dev server (DB keeps running)"
    Write-Host "  stop -All          Stop dev server + PostgreSQL"
    Write-Host "  restart            Restart the dev server"
    Write-Host "  status             Show server + DB status"
    Write-Host "  db start           Start PostgreSQL only"
    Write-Host "  db stop            Stop PostgreSQL only"
    Write-Host "  db reset           Drop + recreate database and reseed"
    Write-Host "  db status          Show database status"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Background, -b    Run the server in background mode"
    Write-Host "  -All, -a           Also stop PostgreSQL (with 'stop' command)"
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
    "db" {
        switch ($SubCommand) {
            "start"  { Start-Db | Out-Null }
            "stop"   { Stop-Db }
            "reset"  { Reset-Db }
            "status" { Show-DbStatus }
            default  { Show-DbStatus }
        }
    }
    "help"    { Show-Usage }
}
