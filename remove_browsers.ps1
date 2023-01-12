<#
.SYNOPSIS
    Remove Web Browsers - Mozilla Firefox, Google Chrome and Opera
.DESCRIPTION
    This PowerShell script removes the web browsers.Some of these paths might differ depending on where you have installed the browsers and the version of browsers and windows you have. You also need to run the script as administrator or use an elevated PowerShell session. Please review the scripts and take your own risks.Run the script with as administrator or use an elevated PowerShell session on the target workstation. Or create the scripts in SCCM and deploy it to selected collections.
.EXAMPLE
    PS> ./remove_browsers

.LINK
    https://github.com/volkanu/powershell
.NOTES
    Author: Volkan U | License: CC0
#>

# Uninstall Firefox via the command line
Start-Process -FilePath "msiexec.exe" -ArgumentList '/x {EC8030F7-C20A-464F-9B0E-13A3A9E97384} /quiet' -Wait

# Remove Firefox user data
Remove-Item -Path "$env:APPDATA\Mozilla\Firefox" -Recurse -Force

# Remove Firefox program files
Remove-Item -Path "$env:ProgramFiles\Mozilla Firefox" -Recurse -Force

# Remove Firefox from the start menu
Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk" -Force

# Uninstall Google Chrome via the command line
$chrome = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "Google Chrome*"}
$chrome.Uninstall()

# Remove Google Chrome user data
Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome" -Recurse -Force
Remove-Item -Path "$env:APPDATA\Google\Chrome" -Recurse -Force

# Remove Google Chrome shortcuts
Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" -Force
Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Chrome Apps.lnk" -Force

# Uninstall Opera via the command line
$opera = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "Opera*"}
$opera.Uninstall()

# Remove Opera user data
Remove-Item -Path "$env:APPDATA\Opera Software" -Recurse -Force

# Remove Opera program files
Remove-Item -Path "$env:ProgramFiles\Opera" -Recurse -Force

# Remove Opera from the start menu
Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Opera.lnk" -Force