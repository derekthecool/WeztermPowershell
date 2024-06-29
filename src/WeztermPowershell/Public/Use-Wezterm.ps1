$wezterm_binary = Get-Command wezterm -ErrorAction SilentlyContinue

<#
    .SYNOPSIS
    Powershell wrapper around the wezterm cli interface

    .DESCRIPTION
    Easily call wezterm and run commands

    .EXAMPLE
    PS> Use-Wezterm
#>
function Use-Wezterm
{
    if($null -eq $wezterm_binary)
    {
        Write-Error "wezterm not found in path!"
        return 1
    }

    & "$wezterm_binary" $args
}

New-Alias -Name wezterm -Value Use-Wezterm
