# Logon Types
https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4625
|Logon Type|Logon Title|Description|
|---|---|---|
|2|Interactive|A user logged onto this computer.|
|3|Network|A user or computer logged on to this computer from the network.|
|4|Batch|Batch logon type is used by batch servers, where processes may be executing on behalf of a user without their direct intervention.|
|5|Service|A service was started by the Service Control Manager.|
|7|Unlock|This workstation was unlocked.|
|8|NetworkCleartext|A user logged on to this computer from the network. The user's password was passed to the authentication package in its unhashed form. The built-in authentication packages all hash credentials before sending them across the network. The credentials do not traverse the network in plaintext (also called cleartext).|
|9|NewCredentials|A caller cloned its current token and specified new credentials for outbound connections. The new logon session has the same local identity, but uses different credentials for other network connections.|
|10|RemoteInteractive|A user logged on to this computer remotely using Terminal Services or Remote Desktop.|
|11|CachedInteractive|A user logged on to this computer with network credentials that were stored locally on the computer. The domain controller was not contacted to verify the credentials.|

# Logon Status Codes
https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4625
|Status\Sub-Status Code|Description|
|---|---|
|0XC000005E|There are currently no logon servers available to service the logon request.
|0xC0000064|User logon with misspelled or bad user account
|0xC000006A|User logon with misspelled or bad password
|0XC000006D|The cause is either a bad username or authentication information
|0XC000006E|Indicates a referenced user name and authentication information are valid, but some user account restriction has prevented successful authentication (such as time-of-day restrictions).
|0xC000006F|User logon outside authorized hours
|0xC0000070|User logon from unauthorized workstation
|0xC0000071|User logon with expired password
|0xC0000072|User logon to account disabled by administrator
|0XC00000DC|Indicates the Sam Server was in the wrong state to perform the desired operation.
|0XC0000133|Clocks between DC and other computer too far out of sync
|0XC000015B|The user has not been granted the requested logon type (also called the logon right) at this machine
|0XC000018C|The logon request failed because the trust relationship between the primary domain and the trusted domain failed.
|0XC0000192|An attempt was made to logon, but the Netlogon service was not started.
|0xC0000193|User logon with expired account
|0XC0000224|User is required to change password at next logon
|0XC0000225|Evidently a bug in Windows and not a risk
|0xC0000234|User logon with account locked
|0XC00002EE|Failure Reason: An Error occurred during Logon
|0XC0000413|Logon Failure: The machine you are logging on to is protected by an authentication firewall. The specified account is not allowed to authenticate to the machine.
|0x0|Status OK.

# Connection methods and credentials sent
https://docs.microsoft.com/en-us/windows-server/identity/securing-privileged-access/reference-tools-logon-types
|Connection method|Logon type|Reusable credentials on destination|Comments|
|---|---|---|---|
|Log on at console|Interactive|v|Includes hardware remote access / lights-out cards and network KVMs.|
|RUNAS|Interactive|v||
|RUNAS /NETWORK|NewCredentials|v|Clones current LSA session for local access, but uses new credentials when connecting to network resources.|
|Remote Desktop (success)|RemoteInteractive|v|If the remote desktop client is configured to share local devices and resources, those may be compromised as well.|
|Remote Desktop (failure - logon type was denied)|RemoteInteractive|-|By default, if RDP logon fails credentials are only stored briefly. This may not be the case if the computer is compromised.|
|Net use * \\SERVER|Network|-||
|Net use * \\SERVER /u:user|Network|-||
|MMC snap-ins to remote computer|Network|-|Example: Computer Management, Event Viewer, Device Manager, Services|
|PowerShell WinRM|Network|-|Example: Enter-PSSession server|
|PowerShell WinRM with CredSSP|NetworkClearText|v|New-PSSession server|
|-Authentication Credssp|
|-Credential cred|
|PsExec without explicit creds|Network|-|Example: PsExec \\server cmd|
|PsExec with explicit creds|Network + Interactive|v|PsExec \\server -u user -p pwd cmd|
|Creates multiple logon sessions.|
|Remote Registry|Network|-||
|Remote Desktop Gateway|Network|-|Authenticating to Remote Desktop Gateway.|
|Scheduled task|Batch|v|Password will also be saved as LSA secret on disk.|
|Run tools as a service|Service|v|Password will also be saved as LSA secret on disk.|
|Vulnerability scanners|Network|-|Most scanners default to using network logons, though some vendors may implement non-network logons and introduce more credential theft risk.|
