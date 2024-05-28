function Update-PSProfile {
    $Url = "https://raw.githubusercontent.com/stuart938503/Misc-PS-Public/main/profile.ps1"

    try {
        $ProfileResponse = Invoke-RestMethod $Url -ErrorAction Stop
        Set-Content -Path $profile -Value $ProfileResponse
        Write-Verbose "Updated PS profile" -Verbose
        . $profile
    }
    catch {
        Write-Verbose -Verbose "Was not able to access gist, try again next time"
        Write-Debug $_
    }
}
