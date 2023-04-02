<#
.SYNOPSIS
    Check the domain admin group members
.DESCRIPTION
    This PowerShell script checks domain admin group members in a timely manner and sends a mail if any change happens.
.EXAMPLE
    PS> ./check_domain_admins
.LINK
    https://github.com/kbsuperuser/powershell
.NOTES
    Author: kbsuperuser.com | License: CC0
#>

Import-Module activedirectory

$ref=(Get-ADGroupMember -Identity "Domain Admins").Name
Start-Sleep -Seconds 3600

$diff=(Get-ADGroupMember -Identity "Domain Admins").Name
$date=Get-Date -Format g

$result=(Compare-Object -ReferenceObject $ref -DifferenceObject $diff | Where-Object {$_.SideIndicator -eq "=>"} | Select-Object -ExpandProperty InputObject) -join ", "

If ($result)
{Send-MailMessage -From SecurityAlert@kbsuperuser.com -To sys_admin@kbsuperuser.com -SmtpServer relay.kbsuperuser.com -Subject "Domain Admin Alert" -Body "$result have been added to domain admins group. Date : $date" -Priority High -Encoding UTF8}