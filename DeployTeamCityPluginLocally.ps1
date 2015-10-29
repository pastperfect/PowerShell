#Compile and generate the plugin
#cd C:\Development\teamcity\HelloPlugin
#mvn package

$pluginDevRoot = "C:\Development\irv-edctfs-901\IrvineDev\InternalApps\ParexelIrvineTeamCityPlugin"

$TCPluginDir = "C:\ProgramData\JetBrains\TeamCity\Plugins"

Function StopTeamCityServer
{
    $teamCityService = Get-Service -Name "TeamCity Server"
    Write-Host  "Stopping TeamCity Server..."
    If ($teamCityService.CanStop)
    {
        $teamCityService.Stop()
        $teamCityService.WaitForStatus("Stopped")
        Write-Host  "TeamCity Server stopped"
    }
}

Function StartTeamCityServer
{
    $teamCityService = Get-Service -Name "TeamCity Server"
    Write-Host "Starting the TeamCity Server..."
    $teamCityService.Start()
    $teamCityService.WaitForStatus("Running")
    Write-Host "TeamCity Server started"
}

Function DeleteAllTeamCityPlugins($TeamCityPluginDir)
{
    Write-Host "Deleting all custom plugins from TeamCity..."
    Remove-Item ($TeamCityPluginDir + "\*") -Recurse
}

Function CopyTeamCityPlugin($SourceZipPath, $TeamCityPluginDir)
{
    Write-Host "Copying the plugin $SourceZipPath ..."
    Copy-Item -Path $SourceZipPath -Destination $TeamCityPluginDir
}


StopTeamCityServer
DeleteAllTeamCityPlugins $TCPluginDir

CopyTeamCityPlugin -SourceZipPath "$pluginDevRoot\target\ParexelIrvineTeamCityPlugin.zip"  -TeamCityPluginDir $TCPluginDir

StartTeamCityServer

Write-Host ("Completed at " + (Get-Date)) -ForegroundColor Yellow
