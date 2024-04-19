# Work in Progress

function LoginLast24h {
    Get-WinEvent -FilterHashtable @{ LogName = 'Security'; ID = 4624; StartTime=(Get-Date).AddDays(-1);data='tcadmin' } | ForEach-Object {
    [PSCustomObject]@{
        TimeGenerated = $_.TimeCreated
        UserName      = $_.Properties[5].Value
        Workstation   = $_.MachineName
    }
} | Measure-Object -Sum 

}

$numberOflogins = LoginLast24h

$message = $numberOflogins.Count

$DateSince = (Get-Date).AddDays(-1)

$msg = Write-Output "The Account NameOfAccount has logged in" $message "times since" $DateSince "."

Invoke-WebRequest -Uri "https://ntfy.sh/mytestingtopic_012345" -Method POST -Body $msg