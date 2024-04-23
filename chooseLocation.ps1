$location = @("Capel", "Dalyellup", "Boyanup")

$menuIndex = 1
Write-Host "Choose Library Location"
$location | foreach {
    Write-Host $menuIndex " - $_";
    $menuIndex += 1;
 }


$ChosenItem = [int](Read-Host "Your choice (1 to $($menuIndex-1))")

$location = $location[$ChosenItem-1]

Write-Output "`$location=$location"