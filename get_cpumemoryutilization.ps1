<#
.SYNOPSIS
   CPU and Memory Utilization
.DESCRIPTION
    This PowerShell script gets the server names from a text file and shows the CPU and Memory Usage of the target server.
.EXAMPLE
    PS> ./get_cpumemoryutilization

.LINK
    https://github.com/volkanu/powershell
.NOTES
    Author: Volkan U | License: CC0
#>

# Define the txt file location to run the script 
$Servers = Get-Content "C:\ServerList.txt"
$Array = @()
  
ForEach($Server in $Servers)
{
    $Server = $Server.trim()
 
    Write-Host "Checking: $Server"
 
    $Check = $null
    $Processor = $null
    $ComputerMemory = $null
    $RoundMemory = $null
    $Object = $null
 
    # Creating custom object
    $Object = New-Object PSCustomObject
    $Object | Add-Member -MemberType NoteProperty -Name "Server name" -Value $Server
 
    $Check = Test-Path -Path "\\$Server\c$" -ErrorAction SilentlyContinue
 
    If($Check -match "True")
    {
        $Status = "True"
 
        Try
        {
            # CPU Utilization
            $Processor = (Get-WmiObject -ComputerName $Server -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average
  
            # Memory Utilization
            $ComputerMemory = Get-WmiObject -ComputerName $Server -Class win32_operatingsystem -ErrorAction Stop
            $Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize)
            $RoundMemory = [math]::Round($Memory, 2)
        }
        Catch
        {
            Write-Host "Something went wrong." -ForegroundColor Red
            Continue
        }
 
        If(!$Processor -and $RoundMemory)
        {
            $RoundMemory = "(null)"
            $Processor = "(null)"
        }
 
        $Object | Add-Member -MemberType NoteProperty -Name "Is Server Online?" -Value $Status
        $Object | Add-Member -MemberType NoteProperty -Name "Memory %" -Value $RoundMemory
        $Object | Add-Member -MemberType NoteProperty -Name "CPU %" -Value $Processor
 
        # Display resutls for single server in realtime
        #$Object
  
        # Adding custom object to our array
        $Array += $Object
    }
    Else
    {
        $Object | Add-Member -MemberType NoteProperty -Name "Is Server Online?" -Value "False"
        $Object | Add-Member -MemberType NoteProperty -Name "Memory %" -Value "(null)"
        $Object | Add-Member -MemberType NoteProperty -Name "CPU %" -Value "(null)"
         
        # Display results for single server in realtime
        #$Object
  
        # Adding custom object to our array
        $Array += $Object
    }
}  
 
    If($Array)
    { 
        $Array | Sort-Object "Is online?"
 
        #$Array | Out-GridView
  
        #$Array | Export-Csv -Path "C:\Result.csv" -NoTypeInformation -Force
    }
