#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'WeztermPowershell'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue')
{
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'WeztermPowershell' {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------

    # Skip these tests if the actual wezterm binary is not found in path
    $skipTests = -not $Global:wezterm_binary

    Describe 'Register-WeztermPowershellCompletion Private Function Tests' -Tag Unit -Skip:$skipTests {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Context 'Error' {

        }

        Context 'Success' {

            BeforeEach {

            }

            It 'Get-WeztermCompletion wezterm only should return at least 19 items' {
                Get-WeztermCompletion -Command 'wezterm' | Should -HaveCount 19
            }

            It 'Get-WeztermCompletion wezterm only should include these items' {
                $ExpectedItems = @(
                    'start'
                    'ssh'
                    'serial'
                    'connect'
                    'ls-fonts'
                    'show-keys'
                    'cli'
                    'imgcat'
                    'set-working-directory'
                    'record'
                    'replay'
                    'shell-completion'
                    'help'
                    '-n'
                    '--config-file'
                    '--config'
                    '-h'
                    '-V'
                )

                $ActualItems = Get-WeztermCompletion -Command 'wezterm'

                $ActualItems | ForEach-Object { Write-Debug "Actual item found: $_" }

                $ExpectedItems | ForEach-Object {
                    $ActualItems | Should -Contain $_
                }
            }

            It 'Get-WeztermCompletion should be of type string' {
                Get-WeztermCompletion -Command 'wezterm' | Should -BeOfType 'string'
            }
        }
    }
}
