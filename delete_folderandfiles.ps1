<#
.SYNOPSIS
   Delete Folder and Files
.DESCRIPTION
    This PowerShell script deletes all folders and files in a spesific directory. Before deleting the folders and files script creates a csv file and export the details about deleted items. Priviliged account is needed to run the script.
.EXAMPLE
    PS> ./delete_folderandfiles

.LINK
    https://github.com/volkanu/powershell
.NOTES
    Author: Volkan U | License: CC0
#>

# Step 1: Export folder and file information to CSV
$directory = "C:\example\folder\"
$files = Get-ChildItem -Path $directory -Recurse | Select-Object -Property Name, Extension, CreationTime, LastWriteTime, @{Name='CreatedBy'; Expression={(Get-Acl $_.FullName).Owner}}, @{Name='UpdatedBy'; Expression={(Get-Acl $_.FullName).Access | Where-Object {$_.IsInherited -eq $false} | Select-Object -ExpandProperty IdentityReference}}, @{Name='Owner'; Expression={(Get-Acl $_.FullName).Owner}}
$files | Export-Csv -Path "$directory\file_information.csv" -NoTypeInformation

# Step 2: Delete all files and folders
Remove-Item -Recurse -Force $directory

