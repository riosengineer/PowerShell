# PS Script to add Proxy Addresses to AD Users via CSV list 
Import-Module ActiveDirectory
# Specify Path of where the addresses are located. Must be a CSV and have SamAccountName and ProxyAddresses as column headings
$path = Your path to.csv'
$csv=Import-Csv $path

#Script to add the addresses from each csv line
foreach($User in $csv)
{
Foreach($address in $user.ProxyAddresses) { Set-ADUser $User.SamAccountName -Add @{ProxyAddresses=$Address}}
}
