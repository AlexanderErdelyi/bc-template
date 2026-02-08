# PowerShell script to run AL tests
# Usage: .\run-tests.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "bcserver",
    
    [Parameter(Mandatory=$false)]
    [string]$TestSuite = "DEFAULT",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "..\test-results"
)

Write-Host "Running AL Tests" -ForegroundColor Green
Write-Host "================" -ForegroundColor Green

# Ensure output directory exists
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
}

# Check if BcContainerHelper is available
if (-not (Get-Module -ListAvailable -Name BcContainerHelper)) {
    Write-Error "BcContainerHelper module not found. Please run setup-dev-environment.ps1 first."
    exit 1
}

Import-Module BcContainerHelper

# Check if container is running
try {
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

# Run tests
Write-Host "`nRunning tests in container..." -ForegroundColor Yellow
Write-Host "Test Suite: $TestSuite" -ForegroundColor Cyan

try {
    $credential = New-Object PSCredential "admin", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
    
    Run-TestsInBcContainer `
        -containerName $ContainerName `
        -credential $credential `
        -testSuite $TestSuite `
        -XUnitResultFileName (Join-Path $OutputPath "TestResults.xml") `
        -detailed
    
    Write-Host "`nTests completed!" -ForegroundColor Green
    
    # Display results file location
    Write-Host "`nTest results saved to:" -ForegroundColor Yellow
    Write-Host "  $OutputPath\TestResults.xml" -ForegroundColor Cyan
} catch {
    Write-Error "Test execution failed: $_"
    exit 1
}

Write-Host "`nTest execution completed!" -ForegroundColor Green
