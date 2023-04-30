#Powershell Debugging

## What is Debugging
   1) Debugger is an interactive tool built into powershell that allows you to enter a powershell runspace and interate with it
   1) Requires Admin rights to go into another user's process\ runspace
https://devblogs.microsoft.com/scripting/use-the-powershell-debugger/?msclkid=de7f41eaaa1a11ec92977b44228bb637

## Debugging VS Interactive
1) Shows you the status of variables
1) Stop at the point(s) you want
1) Lets you dive into a module context

## Debug Basics
1) h for help

 |Action |Keyboard Shortcut|
|-|-|
|Run/Continue|F5|
|Step Into|F11|
|Step Over|F10|
|Step Out|SHIFT+F11|
|Display Call Stack|CTRL+SHIFT+D|
|List Breakpoints|CTRL+SHIFT+L|
|Toggle Breakpoint|F9|
|Remove All Breakpoints|CTRL+SHIFT+F9|
|Stop Debugger|SHIFT+F5|

## Different ways to debug
### ISE
    1) Built in and nothing to customize
### VSCode
    1) Attach
    1) Interactive
    1) Launch
### Commandline
    1) Wait-Debugger
    1) Set-Breakpoint
    1) Debug-Job
    1) Set-PSDebug
### Remote
    1) Enter-PSHostProcess
    1) get-Runspace
    1) Debug-Runspace
    1) Useful when troubleshooting scripts running non-interactively.
    1) Able to gather information about the runspace environment.

### Examples
1) MultiThreaded runspaces
1) Scheduled task
1) CM Script debugging
1) Azure Automation Hybrid worker


## Disabling debugger
1) Security reasons?

## Tips and Tricks
1) Try catch 
1) export json data for remote
1) Looping allows for a clean break

