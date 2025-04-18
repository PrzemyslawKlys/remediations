<#
    Enable 'Network access: Do not allow storage of passwords and credentials for network authentication'
    https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/network-access-do-not-allow-storage-of-passwords-and-credentials-for-network-authentication
#>

$Key = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$Name = "DisableDomainCreds"

# The value we are expecting
[System.Int32] $Value = 1

# Set the current value
$params = @{
    Path        = $Key
    Name        = $Name
    Value       = $Value
    ErrorAction = "Stop"
}
Set-ItemProperty @params | Out-Null

$params = @{
    Path = $Key
    Name = $Name
}
$Property = Get-ItemProperty @params
if ($Property.$Name -eq $Value) {
    exit 0
} else {
    exit 1
}
