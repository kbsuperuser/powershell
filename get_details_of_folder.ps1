<#
.SYNOPSIS
    This PowerShell script retrieves details for files inside item folders inside a specified folder, including the file name, size, creator, and last editor. The script exports the results to a CSV file in the same folder.

.DESCRIPTION
    This PowerShell script is designed to retrieve details for files inside item folders inside a specified folder. The script uses the Get-ChildItem cmdlet with the -Recurse parameter to get all items (files and folders) inside the specified folder, including items in subfolders.

.EXAMPLE
    Run the script in the host machine.

.LINK
    https://github.com/kbsuperuser/powershell
.NOTES
    Author: kbsuperuser.com | License: CC0
#>

$FolderPath = "C:\DestinationFolder"  # Replace with your folder path
$ExportPath = Join-Path $FolderPath "FileDetails.csv"

Get-ChildItem -Path $FolderPath -Recurse | Where-Object {$_.PSIsContainer} | ForEach-Object {
    $ItemFolder = $_
    Get-ChildItem -Path $ItemFolder.FullName | Where-Object {!$_.PSIsContainer} | ForEach-Object {
        $File = $_
        $FileDetails = @{
            "Name" = $File.Name
            "ItemType" = "File"
            "Size" = $File.Length
            "CreatedBy" = (Get-Acl $File.FullName).Owner
            "LastEdited" = $File.LastWriteTime
            "ParentFolder" = $ItemFolder.Name
        }
        New-Object -TypeName PSObject -Property $FileDetails
    }
} | Export-Csv -Path $ExportPath -NoTypeInformation

Write-Host "File details exported to $ExportPath"
