<#
.SYNOPSIS
    Scan Open Ports
.DESCRIPTION
    This PowerShell script scan the devices which are connected to network. After that script test the connection to ports 80, 443 and 22. If any port is open the result will be exported to a csv file. This script may require priviliged account and the test can be blocked due the security settings of the devices.
.EXAMPLE
    PS> ./open_ports
.LINK
    https://github.com/kbsuperuser/powershell
.NOTES
    Author: kbsuperuser.com | License: CC0
#>

$devices = Get-NetNeighbor | Select-Object IPAddress, HostName
foreach ($device in $devices) {
    Test-NetConnection -ComputerName $device.IPAddress -Port 80,443,22 -InformationLevel 'Detailed' -WarningVariable openPorts
    $device | Add-Member -MemberType NoteProperty -Name "OpenPorts" -Value $openPorts
}

$devices | Export-Csv -Path "C:\temp\open_ports.csv" -NoTypeInformation
