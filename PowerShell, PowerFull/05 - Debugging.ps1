# Breakpoints


Set-PSBreakpoint -Command 'Import-Module'
#Set-PSBreakpoint -Variable 'Counter'
{
    Set-Location C:\Repos\PoshDebugging\Examples
    Import-Module ..\Module\Module.psm1

    #wait-debugger
    :LoopName For ($Counter = 0; $Counter -NE $Max; $Counter++){
        "Sleeping $Counter"
        #Inspect Module
        Start-UDFSleep
    }
}.invoke()

Get-PSBreakpoint| Remove-PSBreakpoint
