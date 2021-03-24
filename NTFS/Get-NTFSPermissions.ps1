function Get-NTFSPermissions { 
    param (
        [Parameter(Mandatory = $true)] 
        [String]$Path,
        [bool]$IncludeInherited = $false
    )
     
    begin {
        $RootDirectory = Get-Item $Path
        if($IncludeInherited) {
            ($RootDirectory | Get-Acl).Access | Add-Member -MemberType NoteProperty -Name "Path" -Value $($RootDirectory.fullname).ToString() -PassThru 
        } else {
            ($RootDirectory | Get-Acl).Access | ? { $_.IsInherited -eq $false } | Add-Member -MemberType NoteProperty -Name "Path" -Value $($RootDirectory.fullname).ToString() -PassThru 
        }
    } 

    process {
        $Contents = Get-ChildItem -LiteralPath $Path -Recurse

        if ($containers -eq $null) { 
            break
        } 

        if($IncludeInherited) {
            foreach ($Content in $Contents) { 
                (Get-Item -LiteralPath $Content.FullName).GetAccessControl().Access | Add-Member -MemberType NoteProperty -Name "Path" -Value $($Content.fullname).ToString() -PassThru -Force 
            } 
        } else {
            foreach ($Content in $Contents) { 
                (Get-Item -LiteralPath $Content.FullName).GetAccessControl().Access | ? { $_.IsInherited -eq $false } |  Add-Member -MemberType NoteProperty -Name "Path" -Value $($Content.fullname).ToString() -PassThru -Force 
            }
        }
    }
} 
