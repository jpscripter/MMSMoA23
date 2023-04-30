Import-Module .\PerformanceTests.psm1 -Force
Import-Module .\PSP.psm1 -Force

#region Compare Pass by Value and Reference with a 10,000 element array
function Add-ValueArray {
    Param(
        [Parameter(Mandatory=$true)]
        [int[]]$Array,
        [Parameter(Mandatory=$true)]
        [int]$VerifyIndex
    )
    $len = $Array.Count
    Write-Output "Array Length: $($len)"
    for ($i = 0; $i -lt $len; $i++) {
        $Array[$i]++
    }
    Write-Output "Index $($VerifyIndex) incremented to $($Array[$VerifyIndex])"
}

function Add-RefArray {
    Param(
        [Parameter(Mandatory=$true)]
        [ref]$Array,
        [Parameter(Mandatory=$true)]
        [int]$VerifyIndex
    )
    $len = $Array.Value.Count
    Write-Output "Array Length: $($len)"
    for ($i = 0; $i -lt $len; $i++) {
        $Array.Value[$i]++
    }
    Write-Output "Index $($VerifyIndex) incremented to $($Array.Value[$VerifyIndex])"
}

$VerifyIndex = 9999

$Array1 = 0..9999
$Array2 = 0..9999

$Array1[$VerifyIndex]
$Array2[$VerifyIndex]

Add-ValueArray -Array $Array1 -VerifyIndex $VerifyIndex
Add-RefArray -Array ([ref]$Array2) -VerifyIndex $VerifyIndex

$Array1[$VerifyIndex]
$Array2[$VerifyIndex]
#endregion

#region Compare Memory Usage
$VerifyIndex = 1234

$Array1 = 0..9999
$Array2 = 0..9999

$Array1[$VerifyIndex]
$Array2[$VerifyIndex]

Test-MemoryImpact -ScriptBlock {$Array3 = 0..9999; Add-ValueArray -Array @($Array3) -VerifyIndex $VerifyIndex}
Test-MemoryImpact -ScriptBlock {$Array4 = 0..9999; Add-RefArray -Array ([ref]$Array4) -VerifyIndex $VerifyIndex}
#endregion

#region Compare Speed
$ByVal = 0..99999
$ByRef = 0..99999
$VerifyIndex = 6789

$Left = Test-Performance -Count 10 -ScriptBlock {Add-ValueArray -Array @($ByVal) -VerifyIndex $VerifyIndex}
$Right = Test-Performance -Count 10 -ScriptBlock {Add-RefArray -Array ([ref]$ByRef) -VerifyIndex $VerifyIndex}

Get-Winner -AName ByValue -AValue $Left.Median -BName ByReference -BValue $Right.Median
Get-Winner -AName ByValue -AValue $Left.Occurrence[0] -BName ByReference -BValue $Right.Occurrence[0]
#endregion