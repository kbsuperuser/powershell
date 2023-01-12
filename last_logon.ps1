<#
.SYNOPSIS
    Get Last Logon Times of the Users
.DESCRIPTION
    This PowerShell gets AD users last logon time and export the results to a CSV file. Update the destination of CSV file.
.EXAMPLE
    PS> ./last_logon

.LINK
    https://github.com/volkanu/powershell
.NOTES
    Author: Volkan U | License: CC0
#>

Get-ADUser -Filter {enabled -eq $true} -Properties LastLogonTimeStamp | Select-Object Name, @{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('yyyy-MM-dd_hh:mm:ss')}} | Export-CSV = -Path "C:\lastlogon.csv"