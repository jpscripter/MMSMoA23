$MemberJSON = "C:\Users\Scott\Downloads\AllCurrentDiscordUsers.json"
$CurrentCSV = "C:\Users\Scott\Downloads\DiscordExport.csv"
$AttendeeRoleId = 1020108069964894239
$SpeakerRoleId = 980219362210365483

$Current = Import-Csv -Path $CurrentCSV
$RawMembers = Get-Content -Path $MemberJSON
$Members = ConvertFrom-Json $RawMembers

foreach ($member in $Members) {
    if (($AttendeeRoleId -in $member.roles -or $SpeakerRoleId -in $member.roles) -and ($member.user.id -notin $Current.Discord_Id)) {
        Write-Warning "No role for $($member.user.username)#$($member.user.discriminator)"
    } elseif ($AttendeeRoleId -in $member.roles -or $SpeakerRoleId -in $member.roles) {
        Write-Output "Found role for $($member.user.username)#$($member.user.discriminator)"
    } else {
        Write-Output "UNK"
    }
}