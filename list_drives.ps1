<#
.SYNOPSIS
    List Drives
.DESCRIPTION
    This PowerShell script scan the domain and list drives connected to computers. Scripts export the results to CSV file. Update the target path before running. The execution time of the scripts depends on range of network and speed. Priviligied account is needed to use the script.
.EXAMPLE
    PS> ./list drives

.LINK
    https://github.com/volkanu/powershell
.NOTES
    Author: Volkan U | License: CC0
#>

$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
$output = @()
foreach ($computer in $computers) {
    try {
        $drives = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $computer
        foreach ($drive in $drives) {
            $driveInfo = [PSCustomObject]@{
                ComputerName = $computer
                DeviceID = $drive.DeviceID
                VolumeName = $drive.VolumeName
                FreeSpace = $drive.FreeSpace
                Size = $drive.Size
            }
            $output += $driveInfo
        }
    } catch {
        Write-Error "Unable to retrieve drive information from $computer"
    }
}

$output | Export-Csv -Path "C:\path\to\drives.csv" -NoTypeInformation

