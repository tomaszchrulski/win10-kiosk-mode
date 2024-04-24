
    #This script generates shortcuts based on the content of the file ".\Website-Shortcuts.txt" within the same directory.

    #The format of the "Websites-Shortcuts.txt" should be 'https://website.test,NameOfTheShortCut'

    #The ShortCut is created in the 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\'

$downloadPath = "C:\temp"
mkdir $downloadPath
Invoke-WebRequest https://live.sysinternals.com/tools/PsExec64.exe -OutFile $downloadPath\PsExec64.exe
Start-Sleep -Seconds 15
Invoke-WebRequest https://raw.githubusercontent.com/tomaszchrulski/win10-kiosk-mode/main/Website-Shortcuts.txt -OutFile $downloadPath\Website-Shortcuts.txt
Start-Sleep -Seconds 5
Invoke-WebRequest https://raw.githubusercontent.com/tomaszchrulski/win10-kiosk-mode/main/NumberOfLogins.ps1 -OutFile $downloadPath\numberOfLogins.ps1
Start-Sleep -Seconds 5
Invoke-WebRequest https://github.com/tomaszchrulski/raw/main/NumberOfLogins.exe -OutFile $downloadPath\numberOfLogins.exe
Invoke-WebR


    $TextFilePath = "$downloadPath\Website-Shortcuts.txt"

    # Read the content of the text file
    $UrlsAndNames = Get-Content -Path $TextFilePath

    # Loop through each line in the text file
    foreach ($Line in $UrlsAndNames) {
        # Split the line into URL and name (assuming they are separated by a comma)
        $Url, $Name = $Line -split ","

        # Remove any invalid characters from the name to create a valid shortcut filename
        $ValidName = $Name | ForEach-Object { $_ -replace '[^\w\s-]', '' }

        # Define the path for the shortcut
        $ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$ValidName.url"

        # Create the shortcut
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
        $Shortcut.TargetPath = $Url
        $Shortcut.Save()
    }

    Write-Host "Website shortcuts created successfully!"
    Write-Host "PsExec64.exe is downloaded."
    Write-Host "..."

# Set up location for the notification   
$location = @("Capel", "Dalyellup", "Boyanup")

$menuIndex = 1
Write-Host "Choose Library Location"
$location | foreach {
Write-Host $menuIndex " - $_";
$menuIndex += 1;
}

$ChosenItem = [int](Read-Host "Your choice (1 to $($menuIndex-1))")

$location = $location[$ChosenItem-1] # setting global variable to store location
[Environment]::SetEnvironmentVariable("location", $location, [System.EnvironmentVariableTarget]::Machine)

Write-Output "`$location=$location"

# Set up Scheduled Task

Start-Sleep -Seconds 5
#$taskTrigger = New-ScheduledTaskTrigger -Daily -At 4:30pm
$taskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1)
$taskAction = New-ScheduledTaskAction -Execute "C:\temp\numberOfLogins.exe" 
$User = "NT AUTHORITY\SYSTEM"
$taskName= "Public Libraries Logins"
$Principal = New-ScheduledTaskPrincipal -UserID $User -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -Principal $Principal
# testing this line %SystemRoot%\syswow64\WindowsPowerShell\v1.0\powershell.exe -NoLogo -NonInteractive -ExecutionPolicy Bypass -noexit -File

#testing this code for scheduling as system (as I cant get it to work otherwise)
#$action = New-ScheduledTaskAction -Execute foo.exe -Argument "bar baz"
#$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration ([Timespan]::MaxValue)
#$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
#$settings = New-ScheduledTaskSettingsSet -MultipleInstances Parallel

#Register-ScheduledTask -TaskName "tasknamehere" -TaskPath "\my\path" -Action $action -Trigger $trigger -Settings $settings -Principal $principal

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Start-Sleep -Seconds 5
Install-Module -Name PolicyFileEditor -Confirm:$False -Force
Start-Sleep -Seconds 5

$allInOne = "https://raw.githubusercontent.com/tomaszchrulski/win10-kiosk-mode/main/All-in-One.ps1"

C:\temp\PsExec64.exe -accepteula -i -s powershell.exe -Command "Invoke-RestMethod -Uri $allInOne | Invoke-Expression"
Start-Sleep -Seconds 5

Restart-Computer -force
