# PowerShell script to clean up development environment
# Usage: .\cleanup.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "bcserver",
    
    [Parameter(Mandatory=$false)]
    [switch]$RemoveModule
)

Write-Host "Cleaning up BC Development Environment" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# Remove container
Write-Host "`nRemoving BC container..." -ForegroundColor Yellow
try {
    $containerExists = docker ps -a --format "{{.Names}}" | Select-String -Pattern "^$ContainerName$"
    if ($containerExists) {
        # Stop container if running
        $containerRunning = docker ps --format "{{.Names}}" | Select-String -Pattern "^$ContainerName$"
        if ($containerRunning) {
            Write-Host "Stopping container..." -ForegroundColor Yellow
            docker stop $ContainerName
        }
        
        # Remove container
        Write-Host "Removing container..." -ForegroundColor Yellow
        docker rm $ContainerName
        Write-Host "Container removed successfully" -ForegroundColor Green
    } else {
        Write-Host "Container '$ContainerName' not found" -ForegroundColor Yellow
    }
} catch {
    Write-Warning "Failed to remove container: $_"
}

# Clean output directories
Write-Host "`nCleaning output directories..." -ForegroundColor Yellow
$outputDirs = @("..\output", "..\test-results", "..\.alpackages")
foreach ($dir in $outputDirs) {
    if (Test-Path $dir) {
        try {
            Remove-Item -Path $dir -Recurse -Force
            Write-Host "Removed: $dir" -ForegroundColor Green
        } catch {
            Write-Warning "Failed to remove $dir : $_"
        }
    }
}

# Remove BcContainerHelper module if requested
if ($RemoveModule) {
    Write-Host "`nRemoving BcContainerHelper module..." -ForegroundColor Yellow
    try {
        Uninstall-Module BcContainerHelper -Force
        Write-Host "Module removed successfully" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to remove module: $_"
    }
}

# Clean Docker images (optional - prompts user)
Write-Host "`nDo you want to remove unused Docker images? (This may free up disk space)" -ForegroundColor Yellow
$response = Read-Host "Enter 'yes' to remove unused Docker images"
if ($response -eq 'yes') {
    Write-Host "Removing unused Docker images..." -ForegroundColor Yellow
    docker image prune -a -f
    Write-Host "Docker images cleaned" -ForegroundColor Green
}

Write-Host "`nCleanup completed!" -ForegroundColor Green
