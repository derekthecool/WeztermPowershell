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
        | ConvertFrom-Text -NoProgress '^\s{2,}(?<CommandOrHelp>[a-z-]{1,2}[a-zA-Z0-9-]+)\b'
        | Sort-Object -Property CommandOrHelp -Unique -CaseSensitive
        | Select-Object -ExpandProperty CommandOrHelp
    }
}

$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    Get-WeztermCompletion -Command $commandAst
    | ForEach-Object {
        $item = $_

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
