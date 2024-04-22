function createWebShortcuts {
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

}


function createKiosk {

$assignedAccessConfiguration = @"
<?xml version="1.0" encoding="utf-8"?>
<AssignedAccessConfiguration xmlns="http://schemas.microsoft.com/AssignedAccess/2017/config" xmlns:rs5="http://schemas.microsoft.com/AssignedAccess/201810/config" xmlns:v3="http://schemas.microsoft.com/AssignedAccess/2020/config">
  <Profiles>
    <Profile Id="{9A2A490F-10F6-4764-974A-43B19E722C25}">
      <AllAppsList>
        <AllowedApps>
          <App AppUserModelId="Microsoft.WindowsCalculator_8wekyb3d8bbwe!App" />
          <App AppUserModelId="Microsoft.Windows.Photos_8wekyb3d8bbwe!App" />
          <App AppUserModelId="Microsoft.BingWeather_8wekyb3d8bbwe!App" />
          <App AppUserModelId="Microsoft.MSPaint_8wekyb3d8bbwe!Microsoft.MSPaint" />
          <App AppUserModelId="Microsoft.SkypeApp_kzf8qxf38zg5c!App" />
          <App AppUserModelId="Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe!App" />
          <App AppUserModelId="Microsoft.ZuneVideo_8wekyb3d8bbwe!Microsoft.ZuneVideo" />
          <App AppUserModelId="Microsoft.ScreenSketch_8wekyb3d8bbwe!App" />
          <App AppUserModelId="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar" />
          <App AppUserModelId="Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe!App" />
          <App DesktopAppPath="%windir%\explorer.exe" />
          <App AppUserModelId="windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" />
          <App AppUserModelId="%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" />
          <App AppUserModelId="%ProgramFiles(x86)%\Microsoft Office\root\Office16\EXCEL.EXE" />
          <App AppUserModelId="%ProgramFiles(x86)%\Microsoft Office\root\Office16\WINWORD.EXE" />
          <App AppUserModelId="%ProgramFiles(x86)%\Microsoft Office\root\Office16\POWERPNT.EXE" />
          <App DesktopAppPath="%ProgramFiles%\Google\Chrome\Application\chrome.exe" />
          <App DesktopAppPath="%ProgramFiles(x86)%\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" />
          <App DesktopAppPath="%ProgramFiles(x86)%\Adobe\Acrobat Reader DC\Reader\Eula.exe" />
          <App DesktopAppPath="%ProgramData%\Microsoft\Windows\Start Menu\Programs\Accessories\Paint.lnk" />
          <App DesktopAppPath="%windir%\system32\mspaint.exe" />
          <App DesktopAppPath="%ProgramData%\Microsoft\Windows\Start Menu\Programs\Accessories\WordPad.lnk" />
          <App DesktopAppPath="%ProgramFiles%\Windows NT\Accessories\wordpad.exe" />
          <App DesktopAppPath="%AppData%\Roaming\Microsoft\Windows\Start Menu\Programs\MaxxAudio Pro by Waves – Speaker and Microphone Audio Control and Nx 3D Sound.lnk" />
          <App DesktopAppPath="%windir%\System32\DriverStore\FileRepository\wavesapo8de.inf_amd64_b4d0b189ff2aba03\WaveSvc64.exe" />
        </AllowedApps>
      </AllAppsList>
      <rs5:FileExplorerNamespaceRestrictions>
        <rs5:AllowedNamespace Name="Downloads" />
        <v3:AllowRemovableDrives />
      </rs5:FileExplorerNamespaceRestrictions>
      <StartLayout><![CDATA[
                    <LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
                        <LayoutOptions StartTileGroupCellWidth="8" />
                        <DefaultLayoutOverride>
                        <StartLayoutCollection>
                            <defaultlayout:StartLayout GroupCellWidth="8">
                            <start:Group Name="">
                                <start:DesktopApplicationTile Size="2x2" Column="2" Row="4" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" />
                                <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />
                                <start:Tile Size="2x2" Column="2" Row="0" AppUserModelID="Microsoft.Windows.Photos_8wekyb3d8bbwe!App" />
                                <start:Tile Size="2x2" Column="0" Row="0" AppUserModelID="Microsoft.WindowsCalculator_8wekyb3d8bbwe!App" />
                                <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationID="Microsoft.Office.EXCEL.EXE.15"/>
                                <start:DesktopApplicationTile Size="2x2" Column="0" Row="4" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Word.lnk" />
                                <start:DesktopApplicationTile Size="2x2" Column="6" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" />
                                <start:DesktopApplicationTile Size="2x2" Column="4" Row="4" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" />
                                <start:Tile Size="2x2" Column="0" Row="2" AppUserModelID="Microsoft.BingWeather_8wekyb3d8bbwe!App"/>
                                <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationID="com.squirrel.Teams.Teams"/>
                                <start:DesktopApplicationTile Size="2x2" Column="6" Row="2" DesktopApplicationID="%ProgramFiles(x86)%\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"/>
                                <start:Tile Size="2x2" Column="6" Row="4" AppUserModelID="Microsoft.ScreenSketch_8wekyb3d8bbwe!App"/>
                            </start:Group>
                            <start:Group Name="">
                                <start:Tile Size="2x2" Column="0" Row="2" AppUserModelID="Microsoft.Windows.Photos_8wekyb3d8bbwe!App"/>
                                <start:Tile Size="2x2" Column="4" Row="0" AppUserModelID="Microsoft.ZuneVideo_8wekyb3d8bbwe!Microsoft.ZuneVideo"/>
                                <start:Tile Size="2x2" Column="0" Row="0" AppUserModelID="Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe!App"/>
                                <start:Tile Size="2x2" Column="6" Row="0" AppUserModelID="Microsoft.SkypeApp_kzf8qxf38zg5c!App"/>
                                <start:Tile Size="2x2" Column="2" Row="0" AppUserModelID="Microsoft.MSPaint_8wekyb3d8bbwe!Microsoft.MSPaint"/>
                                <start:DesktopApplicationTile Size="2x2" Column="0" Row="4" DesktopApplicationID="Microsoft.Office.ONENOTE.EXE.15"/>
                                <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationID="%ProgramFiles(x86)%\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"/>
                                <start:Tile Size="2x2" Column="2" Row="2" AppUserModelID="Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe!App"/>
                                <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationID="%windir%\system32\mspaint.exe"/>
                                <start:Tile Size="2x2" Column="6" Row="2" AppUserModelID="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar"/>
                            </start:Group>
							<start:Group>
							    <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationID="https://ancestrylibrary.com.au/"/>
                                <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationID="https://my.gov.au/"/>
                                <start:DesktopApplicationTile Size="2x2" Column="6" Row="0" DesktopApplicationID="https://readingeggs.com.au/"/>
                                <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationID="https://earth.google.com/"/>
                                <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationID="https://mathletics.com/au/"/>
                                <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationID="https://trove.nla.gov.au/"/>
                                <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationID="https://slwa.wa.gov.au/"/>
							</start:Group>
                            </defaultlayout:StartLayout>
                        </StartLayoutCollection>
                        </DefaultLayoutOverride>
                    </LayoutModificationTemplate>
                ]]></StartLayout>
      <Taskbar ShowTaskbar="true" />
    </Profile>
  </Profiles>
  <Configs>
    <Config>
      <AutoLogonAccount rs5:DisplayName="MS Learn Example test2" />
      <DefaultProfile Id="{9A2A490F-10F6-4764-974A-43B19E722C25}" />
    </Config>
  </Configs>
</AssignedAccessConfiguration>
"@

$namespaceName="root\cimv2\mdm\dmmap"
$className="MDM_AssignedAccess"
$obj = Get-CimInstance -Namespace $namespaceName -ClassName $className
$obj.Configuration = [System.Net.WebUtility]::HtmlEncode($assignedAccessConfiguration)
Set-CimInstance -CimInstance $obj

}


createWebShortcuts
createKiosk 