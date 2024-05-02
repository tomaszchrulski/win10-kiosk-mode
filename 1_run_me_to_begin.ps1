
<#
    
    This script carries out multiple steps relevant to creation of the KIOSK.
    
    1). It downloads PsExec64.exe from Sysinternals.
    2). Downloads the Website-Shortucts.txt containing list of website shortcuts.
    3). Downloads the NumberOfLogins.exe, which is used as action in Scheduled Task that will run eveyday at 16:30.
    4). Creates Shortcuts to the websites.
    5). Requests the setup of the "Location" (Capel, Dalyellup, Boyanup) and sets it as system wide environment variable.
    6). Requests the <ENDPOINT> to be set up for the notifications on www.ntfy.sh
    7).  
    #This script generates shortcuts based on the content of the file ".\Website-Shortcuts.txt" within the same directory.

    #The format of the "Websites-Shortcuts.txt" should be 'https://website.test,NameOfTheShortCut'

    #The ShortCut is created in the 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\'
#>

$downloadPath = "C:\temp"
mkdir $downloadPath
Invoke-WebRequest https://live.sysinternals.com/tools/PsExec64.exe -OutFile $downloadPath\PsExec64.exe
Start-Sleep -Seconds 8
Invoke-WebRequest https://raw.githubusercontent.com/tomaszchrulski/win10-kiosk-mode/main/Website-Shortcuts.txt -OutFile $downloadPath\Website-Shortcuts.txt
Start-Sleep -Seconds 5
Invoke-WebRequest https://raw.githubusercontent.com/tomaszchrulski/win10-kiosk-mode/main/NumberOfLogins.ps1 -OutFile $downloadPath\numberOfLogins.ps1
Start-Sleep -Seconds 5
Invoke-WebRequest https://github.com/tomaszchrulski/win10-kiosk-mode/raw/main/NumberOfLogins.exe -OutFile $downloadPath\NumberOfLogins.exe
Start-Sleep -Seconds 5


    $TextFilePath = "$downloadPath\Website-Shortcuts.txt"

    # Read the content of the text file
    $UrlsAndNames = Get-Content -Path $TextFilePath

    # Loop through each line in the text file
    foreach ($Line in $UrlsAndNames) {
        # Split the line into URL and name (they have to be separated by a comma)
        $Url, $Name = $Line -split ","

        # Remove any invalid characters from the name to create a valid shortcut filename
        $ValidName = $Name | ForEach-Object { $_ -replace '[^\w\s-]', '' }

        # Define the path for the shortcut
        $ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$ValidName.url"

        # Create the shortcuts
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

# Set up a system variable to store the URL of the endpoint (ntfy.sh/<ENDPOINT>)

Write-Host "..."
Write-Host "Provide a custom ENDPOINT in the format https://ntfy.sh/<ENDPOINT>"
Write-Host "For example: https://ntfy.sh/arisoenar234i2e3n4i23e"
Write-Host "This is used to receive notification from each workstation"

$chosenNtfy = (Read-Host "NTFY.sh address")
[Environment]::SetEnvironmentVariable("chosenNtfy", $chosenNtfy, [System.EnvironmentVariableTarget]::Machine)


# Set up Scheduled Task

Start-Sleep -Seconds 5
#$taskTrigger = New-ScheduledTaskTrigger -Daily -At 4:30pm
$taskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1)
$taskAction = New-ScheduledTaskAction -Execute "C:\temp\NumberOfLogins.exe" 
$User = "NT AUTHORITY\SYSTEM"
$taskName= "Public Libraries Logins"
$Principal = New-ScheduledTaskPrincipal -UserID $User -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -Principal $Principal

# Installing Nuget and PoliciFileEditor to edit Local Security Group Policy
# Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
# Start-Sleep -Seconds 5
# Install-Module -Name PolicyFileEditor -Confirm:$False -Force
# Start-Sleep -Seconds 5

$allInOne = "https://raw.githubusercontent.com/tomaszchrulski/win10-kiosk-mode/main/All-in-One.ps1"

C:\temp\PsExec64.exe -accepteula -i -s powershell.exe -Command "Invoke-RestMethod -Uri $allInOne | Invoke-Expression"
Start-Sleep -Seconds 5

#Set password for the user
net user kioskUser0 Public

Restart-Computer -force
