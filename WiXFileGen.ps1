#WiX file generator

$targetDirPath = "D:\Builds\CacheServicePublish"
$outPutFile = ".\CacheServiceSetup\Files.wxs"

Set-Alias -Name "heat" -Value "$env:WIX\bin\heat.exe"

heat dir `"$targetDirPath`" -cg CacheService -gg -scom -sreg -sfrag -srd -dr CacheService  -var var.Parexel.Engineering.CacheService.ProjectDir -out `"$outPutFile`"

#"$(WIX)bin\heat.exe" dir "$(SuperFormFilesDir)" -cg SuperFormFiles -gg -scom -sreg -sfrag -srd -dr INSTALLLOCATION -var env.SuperFormFilesDir -out "$(ProjectDir)Fragments\FilesFragment.wxs".