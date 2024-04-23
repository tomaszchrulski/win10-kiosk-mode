
    #This script generates shortcuts based on the content of the file ".\Website-Shortcuts.txt" within the same directory.

    #The format of the "Websites-Shortcuts.txt" should be 'https://website.test,NameOfTheShortCut'

    #The ShortCut is created in the 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\'

$downloadPath = "C:\temp"
mkdir $downloadPath
Invoke-WebRequest https://live.sysinternals.com/tools/PsExec64.exe -OutFile $downloadPath\PsExec64.exe
Start-Sleep -Seconds 15
Invoke-WebRequest https://raw.githubusercontent.com/tomaszchrulski/win10-kiosk-mode/main/Website-Shortcuts.txt -OutFile $downloadPath\Website-Shortcuts.txt
Start-Sleep -Seconds 5
Invoke-WebRequest https://raw.githubusercontent.com/tomaszchrulski/win10-kiosk-mode/main/NumberOfLogins.ps1 -OutFile $downloadPath\numberOFlogins.ps1


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
$taskAction = New-ScheduledTaskAction -Execute "PowerShell" -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -noexit -File 'C:\temp\numberOflogins.ps1'"
Register-ScheduledTask 'Public Libraries Logins' -Action $taskAction -Trigger $taskTrigger
# testing this line %SystemRoot%\syswow64\WindowsPowerShell\v1.0\powershell.exe -NoLogo -NonInteractive -ExecutionPolicy Bypass -noexit -File



$allInOne = "https://raw.githubusercontent.com/tomaszchrulski/win10-kiosk-mode/main/All-in-One.ps1"

C:\temp\PsExec64.exe -accepteula -i -s powershell.exe -Command "Invoke-RestMethod -Uri $allInOne | Invoke-Expression"
Start-Sleep -Seconds 5

Restart-Computer -force