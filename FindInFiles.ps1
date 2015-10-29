<#
.Synopsis
   Searches files.
.DESCRIPTION
   Finds files that contains search string.
.EXAMPLE
   Find-InFiles -FindInDir "C:\Temp" -SearchString "Test"
#>

function Find-InFiles
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)] 
        [string] $FindInDir,

        [Parameter(Mandatory=$true,
                   Position=1)] 
        [string] $SearchString,

        [Parameter(Mandatory=$false, Position=2)]
        [string] $FileFilter = "*.*"

    )

    Begin
    {
    }
    Process
    {
        Write-Host "Collecting files in $FindInDir"
        return dir -filter $FileFilter -path $FindInDir -recurse -force | select-string $SearchString -List | % {$_.path}
    }
    End
    {
    }
}