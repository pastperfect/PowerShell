$rootDir = "C:\UnitTestResults"
$dirs = dir -Path $rootDir | where {$_.PSIsContainer}

$count = 0
foreach($dir in $dirs)
{
    Write-Host "Directory " $dir.FullName " found"
    $itemsToDelete = dir -Path $dir.FullName
    foreach($item in $itemsToDelete)
    {
        if ($item.PSIsContainer)
        {
            $item.Delete($true)
        }
        else
        {
            $item.Delete()
        }
        
        $count++
    }
}

Write-Host $count " items were deleted."
