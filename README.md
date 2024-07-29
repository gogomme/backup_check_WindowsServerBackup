# Backup check Windows Server Backup

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/en/5/51/Backup_center_icon.png" alt="Windows Server Backup logo" width="200"/>
</p>

## The objective

The purpose of this script is to check the last status of Windows Server Backup Job.

## The context

This script has been designed for use in the "Tactical RMM" monitoring solution, which allows scripts to be launched from agents installed on machines.

The monitoring solution determines whether the task is correct or in error according to the return code sent. 

## Operating principle

The scripts work with the "Get-WBJob" command in the "windowsserverbackup" module that display Windows Backup information, the "Get-WBJob -Previous 1" display the last Backup job.

[Official documentation for "GET-WBJob"](https://learn.microsoft.com/en-us/powershell/module/windowsserverbackup/get-wbjob?view=windowsserver2022-ps)

The selected objected for verification is "Hresult, ErrorDescription, JobState,StartTime and EndTime"

Specifically Hresult and JobState is important.

### Result

**Note :** The script verify french character string, modify it for other languages.

There are 3 possible scenarios:

- Hresult is 0 and JobState is unknow, the last job can't be determined. The return code is 1 for "Error".
- Hresult is not 0 and JobState is Completed, the last job finished with errors. The return code is 1 for "Error".
- Hresult is 0 and JobState is Completed, the last job finished correctly. no return code.


