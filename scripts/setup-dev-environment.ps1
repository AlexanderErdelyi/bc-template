# PowerShell script to set up BC development environment
# Usage: .\setup-dev-environment.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$BCVersion = "22.0",
    
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "bcserver",
    
    [Parameter(Mandatory=$false)]
    [switch]$AcceptEula
)

Write-Host "Business Central Development Environment Setup" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "This script should be run as Administrator for optimal functionality"
}

# Install BcContainerHelper if not already installed
Write-Host "`nChecking BcContainerHelper module..." -ForegroundColor Yellow
if (-not (Get-Module -ListAvailable -Name BcContainerHelper)) {
    Write-Host "Installing BcContainerHelper module..." -ForegroundColor Yellow
    Install-Module BcContainerHelper -Force -AllowClobber
    Write-Host "BcContainerHelper installed successfully" -ForegroundColor Green
} else {
    Write-Host "BcContainerHelper already installed" -ForegroundColor Green
    
    # Check for updates
    Write-Host "Checking for updates..." -ForegroundColor Yellow
    Update-Module BcContainerHelper -Force
}

# Import the module
Import-Module BcContainerHelper

# Check Docker installation
Write-Host "`nChecking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "Docker is installed: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Error "Docker is not installed or not running. Please install Docker Desktop and try again."
    exit 1
}

# Check if Docker is running
try {
    docker ps | Out-Null
    Write-Host "Docker is running" -ForegroundColor Green
} catch {
    Write-Error "Docker is not running. Please start Docker Desktop and try again."
    exit 1
}

# Create BC Container
Write-Host "`nCreating Business Central container..." -ForegroundColor Yellow
Write-Host "Container Name: $ContainerName" -ForegroundColor Cyan
Write-Host "BC Version: $BCVersion" -ForegroundColor Cyan

$containerParams = @{
    containerName = $ContainerName
    accept_eula = $AcceptEula
    auth = "UserPassword"
    Credential = (New-Object PSCredential "admin", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force))
    updateHosts = $true
    includeAL = $true
    includeCSide = $false
    doNotExportObjectsToText = $true
    memoryLimit = "8G"
}

try {
    New-BcContainer @containerParams
    Write-Host "`nContainer created successfully!" -ForegroundColor Green
} catch {
    Write-Error "Failed to create container: $_"
    exit 1
}

# Get container information
Write-Host "`nContainer Information:" -ForegroundColor Yellow
Get-BcContainerNavVersion -containerOrImageName $ContainerName

# Display connection information
Write-Host "`nConnection Information:" -ForegroundColor Green
Write-Host "Web Client URL: http://$ContainerName/BC/" -ForegroundColor Cyan
Write-Host "Username: admin" -ForegroundColor Cyan
Write-Host "Password: P@ssw0rd" -ForegroundColor Cyan
Write-Host "Server Instance: BC" -ForegroundColor Cyan

# Update launch.json
Write-Host "`nUpdating VS Code launch.json..." -ForegroundColor Yellow
$launchJsonPath = Join-Path $PSScriptRoot "..\.vscode\launch.json"
if (Test-Path $launchJsonPath) {
    $launchJson = Get-Content $launchJsonPath -Raw | ConvertFrom-Json
    
    # Update server settings
    foreach ($config in $launchJson.configurations) {
        if ($config.name -eq "Docker Sandbox") {
            $config.server = "http://$ContainerName"
            $config.serverInstance = "BC"
        }
    }
    
    $launchJson | ConvertTo-Json -Depth 10 | Set-Content $launchJsonPath
    Write-Host "launch.json updated successfully" -ForegroundColor Green
} else {
    Write-Warning "launch.json not found at $launchJsonPath"
}

Write-Host "`nSetup completed successfully!" -ForegroundColor Green
Write-Host "You can now start developing in VS Code and press F5 to deploy to the container." -ForegroundColor Yellow
