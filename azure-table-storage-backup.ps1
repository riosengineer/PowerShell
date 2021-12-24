# Modules & Requirements 
# Download AzCopy v7.3 https://aka.ms/downloadazcopynet later versions do not work 
# Cd to directory where AzCopy 7.3 is installed to 
Import-Module Az.Storage

Connect-AzAccount

# Parameters

$ResourceGroupName = "RGName"
$StorageAccountName = "StorageName"

# Generating Account Key & Creating Context 

$key = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -AccountName $StorageAccountName)[0].Value
$context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $key

# Gather table names in the storage account

$tables = (Get-AzStorageTable –Context $context).CloudTable | Select-Object Name -ExpandProperty Name

# AzCopy backup for each table found
foreach ($table in $tables) {
    Write-Host "Table found: $Table" -ForegroundColor Green
    $source = "https://$StorageAccountName.table.core.windows.net/$table"
    Write-Host "URL generated: $source" -ForegroundColor Green
    .\AzCopy.exe  /Source:$source /dest:"c:\temp\" /sourceKey:"$key" /PayloadFormat:CSV
}
