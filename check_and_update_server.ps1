<#
.SYNOPSIS
    Check the missed upates and update the server with Powershell

.DESCRIPTION
    This PowerShell script checks for and install missed updates and patches on a Microsoft Windows server.

    "Install-WindowsUpdate" cmdlet requires the server to have the Windows Update Agent installed.
    If the server does not have the Windows Update Agent installed, you can download it from the Microsoft website and install it manually.

    "Invoke-CimMethod" cmdlet requires PowerShell 5.1 or later.

.EXAMPLE
    Use the commands as needed.

.LINK
    https://github.com/kbsuperuser/powershell
.NOTES
    Author: kbsuperuser.com | License: CC0
#>

# Open PowerShell with administrator privileges. Use this cmdlet to check for installed updates on the server.
Get-HotFix

# Use this cmdlet to check for available updates. For example, to check for all available updates, you can use the following command:
Get-WindowsUpdate

# If updates are available, use this cmdlet to install them. For example, to install all available updates, you can use the following command:
Install-WindowsUpdate

# Use the Invoke-CimMethod cmdlet to trigger a Windows Update scan and install the updates. For example:
Invoke-CimMethod -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperations -MethodName ScanForUpdates
Invoke-CimMethod -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperations -MethodName InstallUpdates