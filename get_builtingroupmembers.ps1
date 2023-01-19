<#
.SYNOPSIS
   Get Active Directory Builtin Group Members
.DESCRIPTION
    This PowerShell script gets the members of Active Directory Builtin Group Members and export the result to  csv file.
.EXAMPLE
    PS> ./get_builtingroupmembers

.LINK
    https://github.com/volkanu/powershell
.NOTES
    Author: Volkan U | License: CC0
#>

Import-Module ActiveDirectory

$builtinGroups = @("Administrators", "Backup Operators", "Guests", "Users", "Power Users", "Account Operators", "Server Operators", "Print Operators", "Backup Operators", "Replicator")
$Results = @()

foreach ($group in $builtinGroups) {
    $members = Get-ADGroupMember -Identity $group -Recursive | Select-Object Name, SamAccountName
    foreach ($member in $members) {
       $Results += New-Object PSObject -Property @{
        Group = $group
        Name = $member.Name
        SamAccountName = $member.SamAccountName
       }
    }
}
$Results | Export-Csv -Path "C:\temp\AD_builtin_groups_members.csv" -NoTypeInformation

