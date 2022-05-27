# A basic script to extract some information on your Teams setup in your tenant to file
# Author Dan Rios

# Connect to Microsoft Teams PS Module
Write-Host
Write-Host Waiting for authentication. -ForegroundColor Yellow
Write-Host

Connect-MicrosoftTeams -Verbose

Write-Host
Write-Host Successfully connected to MS Teams for the tenant -ForegroundColor Green
Write-Host

# Commands to gather configuration values 
Write-Host
Write-Host Gathering Teams configuration values for Teams Audit Report.. -ForegroundColor Green
Write-Host

$AutoAttendant = (Get-CsAutoAttendant).count
$CallQueues = (Get-CsCallQueue).count
$serviceno = (Get-CsOnlineTelephoneNumber -ActivationState Activated -InventoryType Service).count
$Interop = (Get-CsOnlineUser | Where-Object {$_.TeamsVideoInteropServicePolicy -ne $null} | Select UserPrincipalName, TeamsVideoInteropServicePolicy).count 
try {
    $CRecording = Get-CsTeamsComplianceRecordingPolicy | Where-Object {$_.Enabled -eq 'True'} | Select-Object Identity }
    catch { Write-Host $Error[0] }
$templates = (Get-CsTeamTemplateList | Where-Object {$_.Scope -like 'custom'}).count
$apppolicies = Get-CsTeamsAppSetupPolicy | ForEach-Object {$_.Identity } | Out-String
$webinar = Get-CsTeamsMeetingPolicy | Select-Object Identity, WhoCanRegister, AllowMeetingRegistration, AllowEngagementReport | Out-String
$liveevents = Get-CsTeamsMeetingBroadcastPolicy | Select-Object Identity,AllowBroadcastScheduling, AllowBroadcastTranscription, BroadcastAttendeeVisibilityMode, BroadcastRecordingMode | Out-String
$federation = Get-CsTenantFederationConfiguration -Identity Global | Out-String
$vdi = Get-CsTeamsVdiPolicy -Identity Global | Out-String
$voiceroutes = (Get-CsOnlineVoiceRoute).count
$sbc = (Get-CsOnlineVoiceRoutingPolicy).count

# Parse to CustomObject & Export to file
$path = "C:\users\$env:USERNAME\Desktop\TeamsTenantConfig.txt"

Write-Host
Write-Host Exporting values to txt file -ForegroundColor Green
Write-Host

try {
[PSCustomObject]@{
    AutoAttendant = $AutoAttendant
    CallQueues = $CallQueues
    ServiceNumbers = $serviceno
    InteropPolicy = $Interop
    ComplianceRecording = $CRecording
    CustomTemplates = $templates
    AppPolicies = $apppolicies
    WebinarPolicy = $webinar
    LiveEventPolicy = $liveevents
    Federation = $federation
    VDIPolicy = $vdi
    VoiceRoutes = $voiceroutes
    SBC = $sbc
} | Out-File -FilePath $path

Write-Host
Write-Host Export completed. Location: $path -ForegroundColor Green
Write-Host
}
# Catch any errors
catch {

    Write-Host
    Write-Host Error exporting to txt file: $Error[0] -ForegroundColor Red
    Write-Host
    
}

 # Open the file
 $open = Read-Host "Do you want to open the file? Y/N"
 if ($open -eq 'Y'){ Invoke-Item $path}
