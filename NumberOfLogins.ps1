
# This .ps1 script is to be used to create an .exe (executable file) and set to run at 16:30 everyday.
# The function searches for the event with ID=4624 (successful login) where the username equals a certain user within the last 24h.
# Then, it generates an output of event date,username and workstation. At this stage it is irrelevant but I'm leaving it in.
# The script then sends a Post request to an endpoint on ntfy.sh with information about the number of logins.

function LoginLast24h {
    Get-WinEvent -FilterHashtable @{ LogName = 'Security'; ID = 4624; StartTime=(Get-Date).AddDays(-1);data='kioskUser0' } | Measure-Object
}

$numberOflogins = LoginLast24h

$message = $numberOflogins.Count

$DateSince = (Get-Date).AddDays(-1)
$hostname = hostname
$whoami = "kioskUser0"
$msg = Write-Output "The Account" $hostname\$whoami "has logged in" $message "times since" $DateSince "at" $env:location "Library."

Invoke-RestMethod -Uri $env:chosenNtfy -Method POST -Body $msg