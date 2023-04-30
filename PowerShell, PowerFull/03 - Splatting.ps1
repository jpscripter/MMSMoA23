#region Basic Splatting
function SplattingExample {
    Param(
        [string]$Arg1,
        [Int32]$Arg2,
        [boolean]$Arg3,
        [string]$Arg4
    )
    Write-Output "`e[93mArg1:`e[0m $($Arg1), `e[93mArg2:`e[0m $($Arg2), `e[93mArg3:`e[0m $($Arg3), `e[93mArg4:`e[0m $($Arg4)"
}

$ArgList = @{Arg1="Something"; Arg2=2; Arg3=$false; Arg4="Something Else"}

SplattingExample @ArgList
#endregion

#region Re-using Parameters 
function SplattingExample2 {
    Param(
        [string]$Arg1,
        [Int32]$Arg2,
        [boolean]$Arg3,
        [string]$Arg4
    )
    $Arg1 = $Arg1.ToUpper()
    $Arg2++
    $Arg3 = -not $Arg3
    $Arg4 = $Arg4.ToLower()
    Write-Output "`e[93mArg1:`e[0m $($Arg1), `e[93mArg2:`e[0m $($Arg2), `e[93mArg3:`e[0m $($Arg3), `e[93mArg4:`e[0m $($Arg4)"
}

SplattingExample @ArgList
SplattingExample2 @ArgList
#endregion

#region Overriding Splatted Variables
SplattingExample @ArgList -Arg2 42
#endregion

#region wrapping presents
$StartCommands = @('/c', 'start', '/max', 'notepad.exe')
Start-Process "C:\Windows\System32\cmd.exe" -ArgumentList $StartCommands

Invoke-Command -ScriptBlock {
    Param([string[]]$PassedArgs)
    Start-Process "C:\Windows\System32\cmd.exe" -ArgumentList $PassedArgs
} -ArgumentList $StartCommands

Invoke-Command -ScriptBlock {
    Param([string[]]$PassedArgs)
    Start-Process "C:\Windows\System32\cmd.exe" -ArgumentList $PassedArgs
} -ArgumentList (,$StartCommands)
#endregion