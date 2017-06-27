function Get-UserIdByName
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Last Name
        [Parameter(Mandatory=$False, Position=0)] [string] $LastName = $null,
        # First Name
        [Parameter(Mandatory=$False, Position=1)] [string] $FirstName = $null
    )

    Begin
    {
        ## Check for valid input
        IF ([string]::IsNullOrEmpty($LastName) -and [string]::IsNullOrEmpty($FirstName)){ THROW "You must enter either the First name, Last Name or both." }

        ## Calculate what was entered
        $Process = 0
        IF (!([string]::IsNullOrEmpty($LastName))) { 
            
            # Lastname is populated, increase counter to 1
            $Process ++
            
            IF (!([string]::IsNullOrEmpty($FirstName))) { 
                
                # Firstname is also populated increase counter to 2
                $Process ++ 
                }
            
            }
        }
    Process
    {
        SWITCH ($Process)
        {
            0 { $user = Get-ADUser -f {GivenName -eq $FirstName} }
            1 { $user = Get-ADUser -f {Surname -eq $LastName} }
            2 { $user = Get-AdUser -f {Name -eq "$LastName, $FirstName"} }
        }
    }
    End
    {

        IF ($user -ne $null) { return $user.SamAccountName }
        ELSE { 
                
                SWITCH ($Process)
                {
                    0 { RETURN "Couldn't find any accounts with the firstname: $FirstName" }
                    1 { RETURN "Couldn't find any accounts with the lastname: $LastName" }
                    2 { RETURN "Couldn't any accounts that match $FirstName $LastName" }
                }
                
            }

    }
}