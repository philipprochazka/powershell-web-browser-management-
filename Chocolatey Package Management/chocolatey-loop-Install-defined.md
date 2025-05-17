# Chocolatey Package Installation Script

This script installs a list of predefined software packages using Chocolatey.  
**Prerequisites:**  
    try {
        choco install $PackageName -y
    } catch {
        Write-Host "Failed to install $PackageName. Error: $_"
    }
- Run this script in a PowerShell session with administrative privileges.