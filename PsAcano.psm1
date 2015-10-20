﻿# .ExternalHelp PsAcano.psm1-Help.xml
function Open-AcanoAPI {
    Param (
        [parameter(ParameterSetName="GET",Mandatory=$true,Position=1)]
        [parameter(ParameterSetName="POST",Mandatory=$true,Position=1)]
        [parameter(ParameterSetName="PUT",Mandatory=$true,Position=1)]
        [parameter(ParameterSetName="DELETE",Mandatory=$true,Position=1)]
        [string]$NodeLocation,
        [parameter(ParameterSetName="POST",Mandatory=$true)]
        [switch]$POST,
        [parameter(ParameterSetName="PUT",Mandatory=$true)]
        [switch]$PUT,
        [parameter(ParameterSetName="DELETE",Mandatory=$true)]
        [switch]$DELETE,
        [parameter(ParameterSetName="POST",Mandatory=$true)]
        [parameter(ParameterSetName="PUT",Mandatory=$true)]
        [parameter(ParameterSetName="DELETE",Mandatory=$false)]
        [string]$Data
    )

    $webclient = New-Object System.Net.WebClient
    $credCache = new-object System.Net.CredentialCache
    $credCache.Add($script:APIAddress, "Basic", $script:creds)

    $webclient.Headers.Add("user-agent", "Windows Powershell WebClient")
    $webclient.Credentials = $credCache

    if ($POST) {
        $webclient.Headers.Add("Content-Type","application/x-www-form-urlencoded")
        $webclient.UploadString($script:APIAddress+$NodeLocation,"POST",$Data)

        $res = $webclient.ResponseHeaders.Get("Location")

        return $res.Substring($res.Length-36)
    } elseif ($PUT) {
        $webclient.Headers.Add("Content-Type","application/x-www-form-urlencoded")

        return $webclient.UploadString($script:APIAddress+$NodeLocation,"PUT",$Data)
    } elseif ($DELETE){
        $webclient.Headers.Add("Content-Type","application/x-www-form-urlencoded")

        return $webclient.UploadString($script:APIAddress+$NodeLocation,"DELETE",$Data)
    } else {
        return [xml]$webclient.DownloadString($script:APIAddress+$NodeLocation)
    }
}

# .ExternalHelp PsAcano.psm1-Help.xml
function New-AcanoSession {
    Param (
        [parameter(Mandatory=$true)]
        [string]$APIAddress,
        [parameter(Mandatory=$false)]
        [string]$Port = $null,
        [parameter(Mandatory=$true)]
        [PSCredential]$Credential,
        [parameter(Mandatory=$false)]
        [switch]$IgnoreSSLTrust
    )

    if ($Port -ne $null){
        $script:APIAddress = "https://"+$APIAddress+":"+$Port+"/"
    } else {
        $script:APIAddress = "https://"+$APIAddress+"/"
    }

    $script:creds = $Credential

    if ($IgnoreSSLTrust) {
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    }
}

# .ExternalHelp PsAcano.psm1-Help.xml
function Get-AcanocoSpaces {
[CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$coSpaceID
        [parameter(Mandatory=$true)]
        [parameter(Mandatory=$true)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$coSpaceId,
        [parameter(Mandatory=$false)]
        [parameter(Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$coSpaceID
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$true,Position=1)]
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$coSpaceUserID,
        [string]$coSpaceID
        [parameter(Mandatory=$true)]
        [parameter(Mandatory=$true)]
        [parameter(Mandatory=$true)]
        [string]$coSpaceId,
        [parameter(Mandatory=$true)]
        [string]$UserId,
        [parameter(Mandatory=$true)]
        [string]$coSpaceId,
        [string]$UserId
        [parameter(Mandatory=$true)]
        [parameter(Mandatory=$true)]
        [parameter(Mandatory=$false)]
        [parameter(Mandatory=$false)]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$true,Position=1)]
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$coSpaceAccessMethodID,
        [string]$coSpaceID
        [parameter(Mandatory=$true)]
        [parameter(Mandatory=$false)]
        [parameter(Mandatory=$true)]
        [parameter(Mandatory=$false)]
        [parameter(Mandatory=$true)]
        [string]$coSpaceId,
        [string]$AccessMethodId
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(ParameterSetName="NoOffset",Mandatory=$false)]
        [string]$Filter="",
        [parameter(ParameterSetName="Offset",Mandatory=$true)]
        [parameter(ParameterSetName="NoOffset",Mandatory=$false)]
        [string]$Limit="",
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [string]$Offset=""
    )

    $nodeLocation = "api/v1/outboundDialPlanRules"
    $modifiers = 0

    if ($Filter -ne "") {
        $nodeLocation += "?filter=$Filter"
        $modifiers++
    }

    if ($Limit -ne "") {
        if ($modifiers -gt 0) {
            $nodeLocation += "&limit=$Limit"
        } else {
            $nodeLocation += "?limit=$Limit"
        }

        if($Offset -ne ""){
            $nodeLocation += "&offset=$Offset"
        }
    }

    return (Open-AcanoAPI $nodeLocation).outboundDialPlanRules.outboundDialPlanRule
}

# .ExternalHelp PsAcano.psm1-Help.xml
    Param (
        [parameter(Mandatory=$true,Position=1)]
        [string]$OutboundDialPlanRuleID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$InboundDialPlanRuleID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(ParameterSetName="NoOffset",Mandatory=$false)]
        [string]$Filter="",
        [parameter(ParameterSetName="Offset",Mandatory=$true)]
        [parameter(ParameterSetName="NoOffset",Mandatory=$false)]
        [string]$Limit="",
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [string]$Offset=""
    )

    $nodeLocation = "api/v1/forwardingDialPlanRules"
    $modifiers = 0

    if ($Filter -ne "") {
        $nodeLocation += "?filter=$Filter"
        $modifiers++
    }

    if ($Limit -ne "") {
        if ($modifiers -gt 0) {
            $nodeLocation += "&limit=$Limit"
        } else {
            $nodeLocation += "?limit=$Limit"
        }

        if($Offset -ne ""){
            $nodeLocation += "&offset=$Offset"
        }
    }

    return (Open-AcanoAPI $nodeLocation).forwardingDialPlanRules.forwardingDialPlanRule
}

# .ExternalHelp PsAcano.psm1-Help.xml
    Param (
        [parameter(Mandatory=$true,Position=1)]
        [string]$ForwardingDialPlanRuleID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$CallID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(Mandatory=$true,Position=1)]
        [string]$CallProfileID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$CallLegID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$CallLegProfileID
        [parameter(Mandatory=$true,Position=1)]
        [string]$CallLegProfileID
        [parameter(Mandatory=$true,Position=1)]
        [string]$CallLegID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$DialTransformID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(Mandatory=$true,Position=1)]
        [string]$CallBrandingProfileID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(Mandatory=$true,Position=1)]
        [string]$DtmfProfileID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$IvrID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$IvrBrandingProfileID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$ParticipantID
        [parameter(Mandatory=$true,Position=1)]
        [string]$ParticipantID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$UserID
        [parameter(Mandatory=$true,Position=1)]
        [string]$UserID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(Mandatory=$true,Position=1)]
        [string]$UserProfileID
        [parameter(Mandatory=$true,Position=1)]
        [string]$AlarmID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$TurnServerID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$WebBridgeID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$true)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$CallBridgeID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$SystemDiagnosticID
        [parameter(Mandatory=$true,Position=1)]
        [string]$SystemDiagnosticID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$LdapServerID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$LdapMappingID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$LdapSourceID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$true)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$LdapSyncID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$ExternalDirectorySearchLocationID
    [CmdletBinding(DefaultParameterSetName="NoOffset")]
    Param (
        [parameter(ParameterSetName="Offset",Mandatory=$false)]
        [parameter(Mandatory=$true,Position=1)]
        [string]$TenantID