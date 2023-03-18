#region Adding dad jokes to profiles... 

function Get-DadJoke {
    $header= @{Accept = "Application/json"}
    $joke = Invoke-RestMethod -Uri "https://icanhazdadjoke.com" -Method Get -Headers $header
    return $joke.joke
}
#endregion

#Note if using other terminal mods this might not work as intended
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    [System.Console]::BackgroundColor = "red"
}

#region For PowerShell 7+ we can use ANSI modifiers to change the appearance:
    $PSStyle.Formatting.Debug = "`e[107m`e[34m"
    $PSStyle.Formatting.Verbose = "`e[45m`e[94m"

    #Ansi Modifiers can be used in our profile with Write-Output instead of Write-Host to format the prompt
#endregion

#region Search MSDocs
function Search-MsDocs {
    Param(
        [Object]$Variable
    )
    start microsoft-edge:"https://bing.com/search?q=site:docs.microsoft.com%20$($Variable.GetType().Namespace).$($Variable.GetType().Name)"
}

#endregion