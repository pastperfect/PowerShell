# TeamCity list users and roles
param
(
	[Parameter(Mandatory=$False)] [string]$TeamCityUsername = "",
	[Parameter(Mandatory=$False)] [string]$TeamCityPassword = "",
	[Parameter(Mandatory=$False)] [string]$TfsServer = "",
    [Parameter(Mandatory=$False)] [string]$TeamCityBaseUrl = ""
)

$secpasswd = ConvertTo-SecureString $TeamCityPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($TeamCityUsername, $secpasswd)
$userList = [xml](Invoke-RestMethod -Credential $cred -Uri "$TeamCityBaseUrl/httpAuth/app/rest/users")

Write-Host "TeamCity users that have permission to run builds"
Write-Host "`tProject Developer and System Admin groups"
Write-Host ("`tReport generated at " + (Get-Date))


ForEach($user in $userList.DocumentElement.ChildNodes)
{
    $userid = $user.id
    $userData = [xml](Invoke-RestMethod -Credential $cred -Uri "$TeamCityBaseUrl/httpAuth/app/rest/users/id:$userid")
    $projectDeveloperrole = Select-Xml -Xml $userData -XPath "/user/roles/role[@roleId='PROJECT_DEVELOPER' or @roleId='SYSTEM_ADMIN' or @roleId='PROJECT_ADMIN']"
    
    If ($projectDeveloperrole -ne $null)
    {
        $print = "`t`t" + $user.username + " (" + $user.name + ")"
        Write-Host $print
    }

}