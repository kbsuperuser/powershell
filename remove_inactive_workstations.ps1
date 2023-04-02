<#
.SYNOPSIS
    Remove Inactive Workstations from Active Directory Users and Computers
.DESCRIPTION
    This PowerShell script checks the last logon dates of the computers and remove them if they have not been used in 90 days. Please update the variables regarding with your own environment before using the script.
.EXAMPLE
    PS> ./remove_inactive_workstations
.LINK
    https://github.com/kbsuperuser/powershell
.NOTES
    Author: kbsuperuser.com | License: CC0
#>

Import-Module activedirectory

# Update These Parameters before running the script.
$domain = "kbsuperuser.com"
$DaysInactive = 90
$time = (Get-Date).Adddays(-($DaysInactive))
$date = Get-Date ($time) -UFormat %d.%m.%y
$File = "c:\Inactive_Computers_Results.csv"

# List and export the inactive computers
$CompList = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time -and operatingSystem -notlike "*server*"} -SearchBase "DC=kbsuperuser, DC=com" -Properties Name,LastLogonTimeStamp,OperatingSystem | 
Select-Object Name, OperatingSystem, @{Name="Last Logon TimeStamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | Export-Csv $File -encoding UTF8 -notypeinformation

# Get-ADComputers which have not been logged on last 90 days.
$Computers = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time -and operatingSystem -notlike "*server*"} -SearchBase "DC=kbsuperuser, DC=com" -Properties Name,LastLogonTimeStamp,OperatingSystem |
Select-Object -ExpandProperty Name

# Delete the listed computers and create a log file.
ForEach ($Computer in $Computers)
{   Try {
        Remove-ADComputer -Identity $Computer -ErrorAction Stop -confirm:$false
        Add-Content c:\removed_computers.log -Value "$Computer has been deleted."
    }
    Catch {
        Add-Content c:\not-removed-computers.log -Value "$Computer was not found. $($Error[0])"
    }
}