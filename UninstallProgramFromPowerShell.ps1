#Uninstall a specified software
$app = Get-WmiObject -Class Win32_Product | where {$_.Name -match "Cache WCF Service"}
$app.Uninstall()