function Update-PSProfile {
    $Url = "https://raw.githubusercontent.com/stuart938503/Misc-PS-Public/main/profile.ps1"

    try {
        $gist = Invoke-RestMethod $gistUrl -ErrorAction Stop
        $gistProfile = $gist.Files."profile.ps1".Content
        Set-Content -Path $profile -Value $gistProfile
        Write-Verbose "Updated PS profile" -Verbose
        . $profile
    }
    catch {
        Write-Verbose -Verbose "Was not able to access gist, try again next time"
    }
}
