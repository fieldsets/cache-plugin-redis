#!/usr/bin/env pwsh
Param(
    [Parameter(Mandatory=$false,Position=0)][Int]$priority = 99,
    [Parameter(Mandatory=$false,Position=1)][String]$phase = "run"
)
$script_token = "$($phase)-phase"
$utils_module_path = [System.IO.Path]::GetFullPath("/fieldsets-lib/pwsh/")
Import-Module -Function isPluginPhaseContainer -Name "$($utils_module_path)/plugins.psm1"

Set-Location -Path "/fieldsets-plugins/"
$plugin_dirs = Get-ChildItem -Path "/fieldsets-plugins/*" -Directory | Select-Object FullName, Name, BaseName, LastWriteTime, CreationTime
# Check to make sure all plugin dependencies are met.
foreach ($plugin in $plugin_dirs) {
    if (isPluginPhaseContainer -plugin "$($plugin.BaseName)") {
        if (Test-Path -Path "$($plugin.FullName)/run.sh") {
            Write-Information -MessageData "Running plugin $($plugin.FullName)" -InformationAction Continue
            Set-Location -Path "$($plugin.FullName)"
            chmod +x "$($plugin.FullName)/run.sh"
            & "bash" -c "exec nohup `"$($plugin.FullName)/run.sh`" >/dev/null 2>&1 &"
        }
    }
}
[Environment]::SetEnvironmentVariable("FieldSetsLastCheckpoint", $script_token, "User")
[Environment]::SetEnvironmentVariable("FieldSetsLastPriority", $priority, "User")

Set-Location -Path "/fieldsets/"
Exit
Exit-PSHostProcess