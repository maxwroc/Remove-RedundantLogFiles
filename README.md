# Remove-RedundantLogFiles
Script for removing old log files

## Features
* Shows number of files found
* Lists old files from given directory
* Adds scheduled task in the system to run on daily basis

![image](https://user-images.githubusercontent.com/8268674/116569000-e3b02c80-a900-11eb-8720-f9660ce0c1f4.png)

## Examples

Finds files 30 days old in given directory and asks what to do
```powershell
.\Remove-RedundantLogFiles.ps1 -FolderPath C:\inetpub\logs\LogFiles
```

Finds files 5 days old in given directory and asks what to do
```powershell
.\Remove-RedundantLogFiles.ps1 -FolderPath C:\inetpub\logs\LogFiles -DaysOld 5
```

Removes 10 day old files from given directory without any prompt and logs number of deleted files
```powershell
.\Remove-RedundantLogFiles.ps1 -FolderPath C:\inetpub\logs\LogFiles -DaysOld 10 -RemoveFiles
```
