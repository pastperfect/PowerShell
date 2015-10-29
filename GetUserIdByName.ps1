function Get-UserIdByName
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$False, Position=0)] [string] $LastName = $null,
        [Parameter(Mandatory=$False, Position=1)] [string] $FirstName = $null
    )

    Begin
    {
        if ([string]::IsNullOrEmpty($LastName) -and [string]::IsNullOrEmpty($FirstName))
        {
            throw "Either FirstName or LastName or both parameters have to be provided"
        }
    }
    Process
    {
   
        $user = $null

        if ([string]::IsNullOrEmpty($FirstName))
        {
            $user = Get-ADUser -f {Surname -eq $LastName}
        }
        elseif ([string]::IsNullOrEmpty($LastName))
        {
            $user = Get-ADUser -f {GivenName -eq $FirstName}
        }
        else
        {
            $user = Get-AdUser -f {Name -eq "$LastName, $FirstName"}
        }

        if ($user -ne $null)
        {
            return $user.SamAccountName
        }
        else
        {
            return "Couldn't find anything for $FirstName $LastName"
        }
    }
    End
    {
    }
}