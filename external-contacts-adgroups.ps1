#Check AD PS Module is present 
$module = Get-Module | Where-Object {$_.Name -eq 'ActiveDirectory'}
if ($module -eq $null) { 
                        Write-Host "Loading AD PS Module" 
                        Import-Module ActiveDirectory -ErrorAction SilentlyContinue
                        }

#Specify an OU to perform the search on
$OU = 'OU=example'

#Specify path/filename for export
$path = "C:\temp\extcontactsgrps.csv"

#Search comma
Get-ADGroup -Filter * -SearchBase $OU -Properties member | Select-Object -ExpandProperty member | Get-ADobject -LDAPfilter "objectClass=contact" -Properties Memberof, Mail, whenCreated, whenChanged | Select-Object Name, Mail, memberof, DistinguishedName, whenCreated, whenChanged, ObjectClass | Export-Csv -Path $path

