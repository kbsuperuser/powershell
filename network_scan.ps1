<#
.SYNOPSIS
    Scan Network and Export The Results
.DESCRIPTION
    This PowerShell script scan the networks and export the results to a csv file. Update the network range and destination of the CSV file.
.EXAMPLE
    PS> ./network_scan

.LINK
    https://github.com/kbsuperuser/powershell
.NOTES
    Author: kbsuperuser.com | License: CC0
#>

# Set the network range to scan
$network = "192.168.1.1/24"

# Scan the network and retrieve a list of active devices
$devices = Get-WmiObject -Class Win32_PingStatus -Filter "Address='$network' AND StatusCode=0" | Select-Object -ExpandProperty Address

# Retrieve additional information for each active device
$devices = foreach($device in $devices) {
    $info = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPAddress='$device'"
    [pscustomobject]@{
        "IPAddress" = $device
        "Hostname" = $info.DNSHostName
        "Manufacturer" = $info.Manufacturer
    }
}

# Export the list of active devices to a CSV file
$devices | Export-Csv -Path "C:\temp\devices.csv" -NoTypeInformation

