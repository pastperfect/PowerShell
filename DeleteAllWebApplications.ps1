Import-Module WebAdministration
pushd
cd IIS:
cd 'Sites\Default Web Site'
dir | where {$_.NodeType –eq “application”} | foreach {Remove-WebApplication $_.Name}
popd