## PS Script software check on logon and install if not present. Useful if you have to install software from Group Policy and need to check it's status 
# and retry if necessary 
# Logging including to location of your choice
# Can be put on logon group policy object 
# 
$logpath = "\\Server\example.log"
#Date format
$logdate = Get-Date -Format "dd.MM.yyyy HH:mm"
#Here you can specify the Software you want to check is installed or not, e.g. 'Exclaimer Cloud Signature Update Agent'
$software = "Exclaimer Cloud Signature Update Agent";
#reg key install location
$installed = (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null
function detailsget {

    $details = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, InstallDate
    #Specify the name of the software you're looking for here as well
    $details -Match "Exclaimer Cloud Signature Update Agent"
    
}
$details = detailsget
If(-Not $installed) {
	Write-Output "$logdate $software is not installed on $env:COMPUTERNAME. Attempting reinstall.." >> $logpath
#msi install try if it detects software is not installed - you can specify your remote or local path here including log file output 
    Start-Process -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList "/i `"\\Server\SoftwareDistribution\Exclaimer Agent\exclaimeragent.msi`" /qn /Lv `"\\Server\SoftwareDistribution\Exclaimer Agent\Log\install$env:COMPUTERNAME.log`""
} else {
	Write-Output "$logdate $software is installed on $env:COMPUTERNAME. $details" >> $logpath
}
#end
