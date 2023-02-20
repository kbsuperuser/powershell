<#
.SYNOPSIS
   Create Backup
.DESCRIPTION
    This PowerShell script creates backup to a folder. Scripts create FULL - INCREMENTAL - DIFFERENTIAL backup of a shared folder to a defined backup destination.
.EXAMPLE
    PS> ./create_backup

.LINK
    https://github.com/kbsuperuser/powershell
.NOTES
    Author: kbsuperuser.com | License: CC0
#>

# Define the shared folder to be backed up
$folder = "\\server\sharedfolder"

# Define the backup destination
$backup = "C:\backup"

# Create a full backup of the shared folder
$date = (Get-Date).ToString("yyyyMMdd")
$dest = "$backup\full_$date"
Robocopy $folder $dest /MIR /R:1 /W:1

# Create an incremental backup of the shared folder
$prevbackup = "$backup\full_$date"
$dest = "$backup\inc_$date"
Robocopy $folder $dest /MIR /R:1 /W:1 /XJ /XF *.bak /XD $prevbackup

# Create a differential backup of the shared folder
$prevbackup = "$backup\full_$date"
$dest = "$backup\diff_$date"
Robocopy $folder $dest /MIR /R:1 /W:1 /XJ /XF *.bak /XD $prevbackup
