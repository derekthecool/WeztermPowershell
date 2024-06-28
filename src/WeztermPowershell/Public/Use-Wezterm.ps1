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
    Write-Output "Yay!"
}

New-Alias -Name wezterm -Value Use-Wezterm
