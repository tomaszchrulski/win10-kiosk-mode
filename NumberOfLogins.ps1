# Work in Progress

# This .ps1 script is to be set to run at 16:30 everyday.
# The function searches for the event with ID=4624 (successful login) where the username equals a certain user within the last 24h.
# Then, it generates an output of event date,username and workstation. At this stage it is irrelevant but I'm leaving it in.
# The script then sends a Post request to an endpoint on ntfy.sh with information about the number of logins.

function LoginLast24h {
    Get-WinEvent -FilterHashtable @{ LogName = 'Security'; ID = 4624; StartTime=(Get-Date).AddDays(-1);data='vagrant' } | Measure-Object -Sum 
}

$numberOflogins = LoginLast24h

$message = $numberOflogins.Count

$DateSince = (Get-Date).AddDays(-1)
$hostname = hostname
$whoami = whoami
$msg = Write-Output "The Account" $whoami "has logged in" $message "times since" $DateSince "at" $location"."

Invoke-WebRequest -Uri "https://ntfy.sh/mytestingtopic_012345" -Method POST -Body $msg