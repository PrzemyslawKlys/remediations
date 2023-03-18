<#
    .SYNOPSIS
        Get locale settings for the system.
        Use with Proactive Remediations or PowerShell scripts

    .NOTES
 	    NAME: Detect-SystemLocale.ps1
	    VERSION: 1.0
	    AUTHOR: Aaron Parker
	    TWITTER: @stealthpuppy

    .LINK
        http://stealthpuppy.com
#>
[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification = "Output required by Proactive Remediations.")]
param (
    [System.String] $Locale = "en-AU"
)

# Select the locale
switch ($Locale) {
    "en-US" {
        # United States
        $GeoId = 244
        $Timezone = "Pacific Standard Time"
    }
    "en-GB" {
        # Great Britain
        $GeoId = 242
        $Timezone = "GMT Standard Time"
    }
    "en-AU" {
        # Australia
        $GeoId = 12
        $Timezone = "AUS Eastern Standard Time"
    }
    default {
        # Australia
        $GeoId = 12
        $Timezone = "AUS Eastern Standard Time"
    }
}

# Test regional settings
try {
    # Get regional settings
    Import-Module -Name "International"

    # System locale
    if ($null -eq (Get-WinSystemLocale | Where-Object { $_.Name -eq $Locale })) {
        Write-Host "System locale does not match $Locale."
        Exit 1
    }

    # Language list
    if ($null -eq (Get-WinUserLanguageList | Where-Object { $_.LanguageTag -eq $Locale })) {
        Write-Host "Language list does not match $Locale."
        Exit 1
    }

    # Home location
    if ($null -eq (Get-WinHomeLocation | Where-Object { $_.GeoId -eq $GeoId })) {
        Write-Host "Home location does not match $Locale."
        Exit 1
    }

    # Time zone
    if ($null -eq (Get-TimeZone | Where-Object { $_.Id -eq $Timezone })) {
        Write-Host "Time zone does not match $Timezone."
        Exit 1
    }

    # All settings are good exit cleanly
    Write-Host "All regional settings match $Locale and $Timezone."
    exit 0
}
catch {
    Write-Host $_.Exception.Message
    exit 1
}
