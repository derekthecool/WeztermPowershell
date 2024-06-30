function Get-WeztermCompletion
{
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Command
    )

    Process
    {
        $helpCommand = "$Command --help"
        Write-Verbose "helpCommand:`n$helpCommand"
        $helpOutput = Invoke-Expression "$helpCommand" 2>&1
        Write-Verbose "helpOutput:`n$helpOutput"
        $helpOutput
        | Where-Object { -not ([string]::IsNullOrEmpty($_)) }
        | ConvertFrom-Text -NoProgress '^\s{2,}(?<CommandOrHelp>(-[A-Za-z0-9]|-{2}[a-z][a-z0-9-]+))'
        | Sort-Object -Property CommandOrHelp -Unique -CaseSensitive
    }
}

$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    Get-WeztermCompletion -Command $commandAst
    | ForEach-Object {
        $item = $_.CommandOrHelp

        $CompletionResultValues = @{
            CompletionText      = $item
            ListItemText        = $item
            ResultType          = 'ParameterName'
            ToolTip             = $item
        }

        [System.Management.Automation.CompletionResult]::new(
            $CompletionResultValues['CompletionText'],
            $CompletionResultValues['ListItemText'],
            $CompletionResultValues['ResultType'],
            $CompletionResultValues['ToolTip'])
    }
}

Register-ArgumentCompleter -Native -CommandName "wezterm" -ScriptBlock $scriptblock
