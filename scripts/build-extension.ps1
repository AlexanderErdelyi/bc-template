# PowerShell script to build AL extension
# Usage: .\build-extension.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = "..\src",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "..\output",
    
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "bcserver"
)

Write-Host "Building AL Extension" -ForegroundColor Green
Write-Host "====================" -ForegroundColor Green

# Ensure output directory exists
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
    Write-Host "Created output directory: $OutputPath" -ForegroundColor Yellow
}

# Check if BcContainerHelper is available
if (-not (Get-Module -ListAvailable -Name BcContainerHelper)) {
    Write-Error "BcContainerHelper module not found. Please run setup-dev-environment.ps1 first."
    exit 1
}

Import-Module BcContainerHelper

# Check if container exists
try {
    $containerExists = docker ps -a --format "{{.Names}}" | Select-String -Pattern "^$ContainerName$"
    if (-not $containerExists) {
        Write-Error "Container '$ContainerName' not found. Please run setup-dev-environment.ps1 first."
        exit 1
    }
    
    # Check if container is running
    $containerRunning = docker ps --format "{{.Names}}" | Select-String -Pattern "^$ContainerName$"
    if (-not $containerRunning) {
        Write-Host "Starting container '$ContainerName'..." -ForegroundColor Yellow
        docker start $ContainerName
        Start-Sleep -Seconds 10
    }
} catch {
    Write-Error "Failed to check container status: $_"
    exit 1
}

# Compile the extension
Write-Host "`nCompiling AL extension..." -ForegroundColor Yellow
Write-Host "Project Path: $ProjectPath" -ForegroundColor Cyan
Write-Host "Output Path: $OutputPath" -ForegroundColor Cyan

try {
    Compile-AppInBcContainer `
        -containerName $ContainerName `
        -appProjectFolder $ProjectPath `
        -appOutputFolder $OutputPath `
        -credential (New-Object PSCredential "admin", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force))
    
    Write-Host "`nBuild completed successfully!" -ForegroundColor Green
    
    # List generated .app files
    $appFiles = Get-ChildItem -Path $OutputPath -Filter "*.app"
    if ($appFiles) {
        Write-Host "`nGenerated .app files:" -ForegroundColor Yellow
        foreach ($file in $appFiles) {
            Write-Host "  - $($file.Name)" -ForegroundColor Cyan
        }
    }
} catch {
    Write-Error "Build failed: $_"
    exit 1
}

Write-Host "`nBuild process completed!" -ForegroundColor Green
