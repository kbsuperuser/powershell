<#
.SYNOPSIS
    Get OS Versions
.DESCRIPTION
    This PowerShell script scans the domain and lists "ComputerName, OSName, Version and BuildNumber". Scripts export the results to CSV file. Update the target path before running. The execution time of the scripts depends on range of network and speed. Priviligied account is needed to use the script.
.EXAMPLE
    PS> ./get_osversions

.LINK
    https://github.com/kbsuperuser/powershell
.NOTES
    Author: kbsuperuser.com | License: CC0
#>

$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
$output = @()
foreach ($computer in $computers) {
    try {
        $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer
        $osInfo = [PSCustomObject]@{
            ComputerName = $computer
            OSName = $os.Name
            Version = $os.Version
            BuildNumber = $os.BuildNumber
        }
        $output += $osInfo
    } catch {
        Write-Error "Unable to retrieve OS information from $computer"
    }
}

$output | Export-Csv -Path "C:\path\to\osversions.csv" -NoTypeInformation
