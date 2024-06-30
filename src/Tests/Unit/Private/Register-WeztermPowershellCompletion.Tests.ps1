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

            It 'should return unknown if an error is encountered getting the date' {
                Mock -CommandName Get-Date -MockWith {
                    throw 'Fake Error'
                } #endMock
                Get-Day | Should -BeExactly 'Unknown'
            } #it

        } #context_Error
        Context 'Success' {

            BeforeEach {

            } #beforeEach

            It '1 is 1' {
                1 | Should -BeExactly 1
            } #it

            It 'Get-WeztermCompletion wezterm only should return at least 5' {
                Get-WeztermCompletion -Command 'wezterm' | Should -HaveCount 5
            } #it

        } #context_Success
    } #describe_Get-HellowWorld
} #inModule
