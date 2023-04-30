Import-Module .\PerformanceTests.psm1 -Force
Import-Module .\PSP.psm1 -Force

#region Object Types - Implicit Conversion
$Bool = "true"
$Bool -eq $true

$Bool = 1
$Bool -eq $true

$Bool = "1"
$Bool -eq $true # Can't co from 'String' -> 'Int' -> 'Boolean'

$Bool = "0x01"
$Bool -eq $true
#endregion

#region typecast Variables
#run first
$Loose = "string"
$Loose.GetType().Name
$Loose = 1
$Loose.GetType().Name
$Loose = $false
$Loose.GetType().Name

#run second
$Strict = [string]::new("string")
$Strict.GetType().Name
$Strict = 1
$Strict.GetType().Name

#run third
[string]$Strict = "string"
$Strict.GetType().Name
$Strict = 1
$Strict.GetType().Name
$Strict += 1
$Strict

$Loose = "string"
$Loose = 1
$Loose += 1
$Loose
#endregion

#region Memory Performance
Test-MemoryImpact -ScriptBlock {
    [string[]]$SArray = [string[]]::new(1000)
    for ($i = 0; $i -lt 1000; $i++) {
        $SArray[$i] = $i
    }
}

Test-MemoryImpact -ScriptBlock {
    [Int32[]]$IArray = [Int32[]]::new(1000)
    for ($j = 0; $j -lt 1000; $j++) {
        $IArray[$j] = $j
    }
}
#endregion