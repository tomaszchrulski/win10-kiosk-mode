

1. EASY. 
The Create-Website-Shortcuts.ps1 script needs to run with "Set-ExecutionPolicy Bypass" from directory containing "Website-Shortcuts"

2. MODERATE. 
The "Public Libraries kiosk setup" is a combination of .xml and Powershell. This needs to be run from the system. To achieve this the powershell can be started using
the PsExec64.exe from sysinternals. The command to start it is: "PsExec64.exe -i -s powershell.exe".

The "Public Libraries Kios Setup" references the Applications and Shortcuts, so if new "Website-Shortcuts" are added and created within the "%ProgramData%\Microsoft\Windows\Start Menu\Programs"
then those shortcuts need to be referenced in the "Public Libraries Kiosk Setup".

3. Ensure the Autostart of applications is Disabled.

4. Investigate remove all files in "Downloads", "Desktop", "Documents"

remove-item $env:userprofile\Downloads* -Confirm:$false
remove-item $env:userprofile\Documents* -Confirm:$false
remove-item $env:userprofile\Desktop* -Confirm:$false


The rough run of the script should be as follows:
1. Run Powershell as admin.
2. Download PsExec64.exe (also within the same repository)
3. Run Powershell script directly from Github that will:
    a). Start the Powershell as the "system" user (psexec64.exe -i -s powershell.exe)
    b). Run Functions:
        - Generate Website-Shortcuts based on the Website-Shortcuts.txt file.
        - Generate Kiosk and the autosign-in user based on the location
        - Create scheduled task to run at 16:30 everyday that will send http POST request to the ntfy.sh/<ID>
            - Scheduled task is to count the successful logins for a <USERNAME> and send notification.