# Bootstrap dependencies

# https://docs.microsoft.com/powershell/module/packagemanagement/get-packageprovider
Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null

# https://docs.microsoft.com/powershell/module/powershellget/set-psrepository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# List of PowerShell Modules required for the build
$modulesToInstall = New-Object System.Collections.Generic.List[object]
# https://github.com/pester/Pester
[void]$modulesToInstall.Add(([PSCustomObject]@{
            ModuleName    = 'Pester'
            ModuleVersion = '5.5.0'
        }))
# https://github.com/nightroman/Invoke-Build
[void]$modulesToInstall.Add(([PSCustomObject]@{
            ModuleName    = 'InvokeBuild'
            ModuleVersion = '5.10.5'
        }))
# https://github.com/PowerShell/PSScriptAnalyzer
[void]$modulesToInstall.Add(([PSCustomObject]@{
            ModuleName    = 'PSScriptAnalyzer'
            ModuleVersion = '1.21.0'
        }))
# https://github.com/PowerShell/platyPS
# older version used due to: https://github.com/PowerShell/platyPS/issues/457
[void]$modulesToInstall.Add(([PSCustomObject]@{
            ModuleName    = 'platyPS'
            ModuleVersion = '0.12.0'
        }))
# https://github.com/jdhitsolutions/PSScriptTools
[void]$modulesToInstall.Add(([PSCustomObject]@{
            ModuleName    = 'PSScriptTools'
            ModuleVersion = '2.48.0'
        }))

'Installing PowerShell Modules'
foreach ($module in $modulesToInstall) {
    $installSplat = @{
        Name               = $module.ModuleName
        RequiredVersion    = $module.ModuleVersion
        Repository         = 'PSGallery'
        SkipPublisherCheck = $true
        Force              = $true
        ErrorAction        = 'Stop'
    }
    try {
        Install-Module @installSplat
        Import-Module -Name $module.ModuleName -ErrorAction Stop
        '  - Successfully installed {0}' -f $module.ModuleName
    }
    catch {
        $message = 'Failed to install {0}' -f $module.ModuleName
        "  - $message"
        throw
    }
}

