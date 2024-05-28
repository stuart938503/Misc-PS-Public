function Update-PSProfile {
    $Url = "https://api.github.com/gists/a208d2bd924691bae7ec7904cab0bd8e"

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
