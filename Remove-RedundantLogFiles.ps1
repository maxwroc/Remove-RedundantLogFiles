<#
    .SYNOPSIS
    Cleans up old log files

    .DESCRIPTION
    Script can install itself as a sheduled task

    .PARAMETER FolderPath
    Specifies the file name.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    System.String. Add-Extension returns a string with the extension or file name.

    .EXAMPLE
    Remove files 30 days old
    PS> .\Remove-RedundantLogFiles.ps1 -FolderPath C:\inetpub\logs\LogFiles

    .EXAMPLE
    Remove files 5 days old
    PS> .\Remove-RedundantLogFiles.ps1 -FolderPath C:\inetpub\logs\LogFiles -DaysOld 5

    .EXAMPLE
    Remove files immediatelly and append log
    PS> .\Remove-RedundantLogFiles.ps1 -FolderPath C:\inetpub\logs\LogFiles -DaysOld 10 -RemoveFiles

    .LINK
    Github: https://github.com/maxwroc/Remove-RedundantLogFiles
#>

[CmdletBinding()]
Param(
    [String]$FolderPath,
    [Int]$DaysOld = 30,
    [Switch]$RemoveFiles = $false
)

$ErrorActionPreference = "Stop"



if (-not $FolderPath) {
    Get-Help $PSCommandPath
    exit
}

$FolderPath=$FolderPath.Trim("\")

$filesToRemove = Get-ChildItem –Path $FolderPath -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-1 * $DaysOld))} 
$count = ($filesToRemove | measure).Count

if ($RemoveFiles) {
    Add-Content -Path "$PSCommandPath.log.txt" -Value "$(Get-Date -Format s) $count"
    $filesToRemove | Remove-Item
    exit
}

Write-Host "Found $($count) files to remove in: $FolderPath"
Write-Host
Write-Host "1. List files to remove"
Write-Host "2. Remove found files"
Write-Host "3. Install as scheduled task (daily)"
Write-Host "q. Quit"

$answer = Read-Host "Please choose the action"
Write-Host

switch ($answer)
{
    '1' {
        $filesToRemove | % { Write-Host $_.FullName }
    } '2' {
        $filesToRemove | Remove-Item
    } '3' {
        $argumentString = '-NoProfile -WindowStyle Hidden "' + $PSCommandPath + '" -RemoveFiles -FolderPath "' + $FolderPath + '" -DaysOld ' + $DaysOld
        $action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
          -Argument $argumentString

        $trigger =  New-ScheduledTaskTrigger -Daily -At 3am

        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Log CleanUp Script ($($FolderPath -replace '[^a-zA-Z0-9]', ''))" -Description "Daily log clean-up task for: $FolderPath"
    }
}
