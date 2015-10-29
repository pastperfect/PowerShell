param
(
	[Parameter(Mandatory=$False)] [string]$TeamCityUsername = "",
	[Parameter(Mandatory=$False)] [string]$TeamCityPassword = "",
    [Parameter(Mandatory=$False)] [string]$TeamCityBaseUrl = ""
)

$secpasswd = ConvertTo-SecureString $TeamCityPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($TeamCityUsername, $secpasswd)
$userList = [xml](Invoke-RestMethod -Credential $cred -Uri "$TeamCityBaseUrl/httpAuth/app/rest/users")

$userIDsToDelete = @()

ForEach($user in $userList.DocumentElement.ChildNodes)
{
    $userid = $user.id
    Write-Host ("Getting user data for " + $user.id)
    $userData = [xml] (Invoke-RestMethod -Method Get -Credential $cred -Uri "$TeamCityBaseUrl/httpAuth/app/rest/users/id:$userid")

    If ($userData.DocumentElement.lastLogin -ne $null)
    {
        $lastLoginDateTime = [datetime]::ParseExact($userData.DocumentElement.lastLogin, "yyyyMMdd'T'HHmmsszzz", [System.Globalization.CultureInfo]::InvariantCulture)
    }
    Else
    {
        Continue
    }
    
    $loginAge = [datetime]::Now - $lastLoginDateTime
    If ($loginAge.Days -gt 100)
    {
        $userIDsToDelete += $userid
    }
}

ForEach($IdToDelete in $userIDsToDelete)
{
    $uri = "$TeamCityBaseUrl/httpAuth/app/rest/users/id:$IdToDelete"

    $servicePoint =  [System.Net.ServicePointManager]::FindServicePoint($uri)
    Invoke-RestMethod -Method Delete -Credential $cred -Uri $uri -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer)
    $servicePoint.CloseConnectionGroup("") | Out-Null
    Write-Host ($IdToDelete + " deleted")
}


Write-Host ($userIdsToDelete.Count.ToString() + " user accounts deleted")