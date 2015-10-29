param
(
	[Parameter(Mandatory=$False)] $tfsServerName = "tfsserver",
	$localFolderPath = $(Throw "Please pass localRootPath"),
	$Domain = "",
	$Username = "",
	$Password = "",
	[String[]] $getPaths = $(Throw "Please pass at least one root path to get the latest.")
)

[void] [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
[void] [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.VersionControl.Client")

$credential = $null

if (($Domain -eq "") -or ($Username -eq "") -or ($Password -eq ""))
{
	$credential = Get-Credential -ErrorAction stop
	$credential = [System.Net.NetworkCredential] $credential
}
else
{
	$credential = New-Object System.Net.NetworkCredential($Username, $Password, $Domain)
}

#Create an instance of TeamFoundationServer object.
$tfs = New-Object Microsoft.TeamFoundation.Client.TeamFoundationServer($tfsServerName, $credential) 
$tfs.Authenticate()

# Get the VersionControlServer object to be used to query TFS.
$vcs = $tfs.GetService([Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer])
$ws = $vcs.GetWorkspace($localFolderPath)

[void] $ws.Get($getPaths, [Microsoft.TeamFoundation.VersionControl.Client.VersionSpec]::Latest, "Full", "GetAll")

