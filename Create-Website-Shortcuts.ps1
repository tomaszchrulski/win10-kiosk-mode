#This script generates shortcuts based on the content of the file ".\Website-Shortcuts.txt" within the same directory.

#The format of the "Websites-Shortcuts.txt" should be 'https://website.test,NameOfTheShortCut'

#The ShortCut is created in the 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\'

$TextFilePath = ".\Website-Shortcuts.txt"

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


