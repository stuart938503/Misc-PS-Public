# Updates profile by downloading again from github
function Update-PSProfile {
    $Url = "https://raw.githubusercontent.com/stuart938503/Misc-PS-Public/main/profile.ps1"

    try {
        $ProfileResponse = Invoke-RestMethod $Url -ErrorAction Stop
        Set-Content -Path $profile -Value $ProfileResponse
        Write-Verbose "Updated PS profile" -Verbose
        . $profile
    }
    catch {
        Write-Verbose -Verbose "Was not able to update, try again next time"
        Write-Debug $_
    }
}

# Adds a collection of Graph API permissions to a managed identity in a given tenant
function Add-GraphPermissionsToManagedIdentity()
{
    param(
        [string]$TenantId,
        [string]$ManagedIdentityName,
        [string[]]$Permissions
    )

    # Connect to Microsoft Graph in the specified tenant
    Write-Host "Connecting to Microsoft Graph..."
    if((Get-MgContext).TenantId -ne $TenantId) {
        Connect-MgGraph -TenantId $TenantId -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All,RoleManagement.ReadWrite.Directory"
    }

    # Get the Managed Identity and Graph service principals
    Write-Host "Getting service principals..."
    $GraphPrincipal = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"
    $ManagedIdentityPrincipal = Get-MgServicePrincipal -Filter "DisplayName eq '$ManagedIdentityName'"

    # Add the permissions to the Managed Identity
    foreach($Permission in $Permissions) {
        Write-Host "Adding permission $Permission..."
        $AppRole = $GraphPrincipal.AppRoles | Where-Object {$_.Value -eq $Permission -and $_.AllowedMemberTypes -contains "Application"}
        New-MgServicePrincipalAppRoleAssignment -PrincipalId $ManagedIdentityPrincipal.Id -ServicePrincipalId $ManagedIdentityPrincipal.Id -ResourceId $GraphPrincipal.Id -AppRoleId $AppRole.Id > $null
    }
    
}

function Get-PublicIp {
    (Invoke-WebRequest -Uri "https://api.ipify.org").content
    (Invoke-WebRequest -Uri "https://api64.ipify.org").content
}


# Simple function to start a new elevated process. If arguments are supplied then 
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin
{
    if ($args.Count -gt 0)
    {   
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    }
    else
    {
       Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}

# Emulates tail on the Windows Event Log. Pass in a hash table of filters to use e.g. @{LogName = "Application"}
Function Tail-WinEventLog {
    Param(
        [hashtable]$FilterHashTable,
        [string[]]$Properties
    )

    #Add a StartTime if not passed in
    if (-not $FilterHashTable.ContainsKey("StartTime")) {
        $LatestEvent = Get-WinEvent -FilterHashtable $FilterHashTable -MaxEvents 1
        $LastTimeCreated = $LatestEvent.TimeCreated
        $LastRecordId = $LatestEvent.RecordId
        $FilterHashTable.Add("StartTime",$LastTimeCreated)
    }

    if (-not $PSBoundParameters.ContainsKey("Properties")) {
        $Properties = "TimeCreated","Id","LevelDisplayName","Message"
    }

    while($True) {
        $Events = Get-WinEvent -FilterHashtable $FilterHashTable | ? RecordId -gt $LastRecordId | Sort TimeCreated -Descending

        if($Events) {
            $LastTimeCreated = $Events[0].TimeCreated
            $LastRecordId = $Events[0].RecordId

            $Events | Select-Object -Property $Properties | Format-Table -AutoSize
        }

        Start-Sleep -Seconds 1
    }
}


# Set UNIX-like aliases for the admin command, so sudo <command> will run the command with elevated rights. 
Set-Alias -Name su -Value admin
