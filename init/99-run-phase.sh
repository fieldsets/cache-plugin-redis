#!/usr/bin/env pwsh
Param(
    [Parameter(Mandatory=$false,Position=0)][String]$priority = "99",
    [Parameter(Mandatory=$false,Position=1)][String]$phase = "run"
)
$script_token = "$($phase)-phase"
$module_path = [System.IO.Path]::GetFullPath("/usr/local/fieldsets/lib/pwsh")
Import-Module -Function isPluginPhaseContainer, buildPluginPriortyList -Name "$($module_path)/plugins.psm1"

Set-Location -Path "/usr/local/fieldsets/plugins/" | Out-Null
# Ordered plugins by priority
$plugins_priority_list = buildPluginPriortyList
foreach ($plugin_dirs in $plugins_priority_list.Values) {
    foreach ($plugin_dir in $plugin_dirs) {
        if ($null -ne $plugin_dir) {
            $plugin = Get-Item -Path "$($plugin_dir)" | Select-Object FullName, Name, BaseName, LastWriteTime, CreationTime
            if (isPluginPhaseContainer -plugin "$($plugin.BaseName)") {
                Write-Host "$($phase) Phase for Plugin: $($plugin.BaseName)"
                if (Test-Path -Path "$($plugin.FullName)/run.sh") {
                    Set-Location -Path "$($plugin.FullName)" | Out-Null
                    chmod +x "$($plugin.FullName)/run.sh" | Out-Null
                    & "bash" -c "exec nohup `"$($plugin.FullName)/run.sh`" >/dev/null 2>&1 &"
                }
            }
        }
    }
}
[System.Environment]::SetEnvironmentVariable("FieldSetsLastCheckpoint", $script_token, "User")
[System.Environment]::SetEnvironmentVariable("FieldSetsLastPriority", $priority, "User")

Set-Location -Path "/usr/local/fieldsets/apps/" | Out-Null
Exit
