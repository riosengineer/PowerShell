# Connect to Key Vault with MI and get secret values
Connect-AzAccount -Identity
$tenantId = Get-AzKeyVaultSecret -VaultName "kv-rios-example" -Name "tenantId" -AsPlainText
$appId = Get-AzKeyVaultSecret -VaultName "kv-rios-example" -Name "appId" -AsPlainText
$spnsecret = Get-AzKeyVaultSecret -VaultName "kv-rios-example" -Name "ecret" -AsPlainText


# Login to Sandbox Tenant via SPN
$secret = ConvertTo-SecureString -String $spnsecret -AsPlainText -Force
$pscredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $appId, $secret
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId -Verbose

# Get subscriptions
$subscriptions = Get-AzSubscription

# Loop through each subscription and delete resource groups as background job
foreach ($subscription in $subscriptions) {
    Select-AzSubscription -SubscriptionId $subscription.Id
    $resourceGroups = Get-AzResourceGroup
    # Loop through each resource group
    foreach ($resourceGroup in $resourceGroups) {
        $lock = Get-AzResourceLock -ResourceGroupName $resourceGroup.ResourceGroupName
        if ($lock -eq $null) {
            Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force -AsJob
            Write-Output "Sending delete job for Resource Group: $($resourceGroup.ResourceGroupName)."
        }
        else {
            Write-Output "Resource group $($resourceGroup.ResourceGroupName) has a resource lock present so cannot be deleted."
        }
    }
}
