#Question
$ErrorActionPreference = 'Stop'
$Q = Read-Host "Do you want to clear Teams cache? [Y/N]"
if ($Q -eq "Y") {
Write-Host "Closing Teams.." -BackgroundColor Yellow -ForegroundColor Black
#Closing Teams
Try {
$Teams=Get-Process -ProcessName Teams | Stop-Process -Force -PassThru 
Start-Sleep -s 3
if ($Teams.ExitCode -ne 0) {
    Write-Output ($Teams.ExitCode) -ErrorAction Stop 
    }
}
Catch {
$Error[0].Exception 
Write-Host "Stopping Teams Cache clear process." -BackgroundColor Yellow -ForegroundColor Black
Exit
    }
#If No errors from closing Teams then begin cache clear
Write-Host "Clearing Teams cache" -BackgroundColor Yellow -ForegroundColor Black
Try { 
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\application cache" | Remove-Item -Confirm:$false -Recurse -Force -ErrorAction Continue
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\blob_storage" | Remove-Item -Confirm:$false -Recurse -Force -ErrorAction Continue
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\databases" | Remove-Item -Confirm:$false -Recurse -Force -ErrorAction Continue
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\cache" | Remove-Item -Confirm:$false -Recurse -Force -ErrorAction Continue
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\gpucache" | Remove-Item -Confirm:$false -Recurse -Force -ErrorAction Continue
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Indexeddb" | Remove-Item -Confirm:$false -Recurse -Force -ErrorAction Continue
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Local Storage" | Remove-Item -Confirm:$false -Recurse -Force -ErrorAction Continue
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\tmp" | Remove-Item -Confirm:$false -Recurse -Force -ErrorAction Continue
Start-Sleep -s 3
} Catch { 
$Error[0].Exception 
Exit
}
#Relaunching Teams
Write-Host "Teams cache cleared! Launching Teams.." -BackgroundColor Green -ForegroundColor Black
Start-Process Teams -FilePath $env:LOCALAPPDATA\Microsoft\Teams\current\Teams.exe
}
#Exit if no to question at the start
elseif ($Q -eq "N") { 
Write-Host "Exiting clear cache script." -BackgroundColor Yellow -ForegroundColor Black
Exit
}
