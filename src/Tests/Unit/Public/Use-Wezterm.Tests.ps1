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
    Describe 'Use-Wezterm Public Function Tests: does not require wezterm to be installed to test' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Context 'Error' {

            It 'If wezterm_binary global is null should throw' {
                $saved = $Global:wezterm_binary
                $Global:wezterm_binary = $null
                {Use-Wezterm --help | Should -Throw }
                $Global:wezterm_binary = $saved
            }

            It 'sic test should pass' {
                Use-Wezterm --help | Should -Not -BeNullOrEmpty
            }

        } #context_Error
        Context 'Success' {

        } #context_Success
    } #describe_Get-HellowWorld

    # Skip these tests if the actual wezterm binary is not found in path
    $skipTests = -not $Global:wezterm_binary

    Describe 'Use-Wezterm Public Function Tests: DOES require wezterm to be installed to test' -Tag Unit -Skip:$skipTests {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Context 'Error' {

        }

        Context 'Success' {
            It 'Calling Use-Wezterm should not be null' {
                Use-Wezterm --help | Should -Not -BeNullOrEmpty
            }

            It 'Calling Use-Wezterm should not throw' {
                { Use-Wezterm --help | Should -Not -Throw }
            }
        }
    }
}
