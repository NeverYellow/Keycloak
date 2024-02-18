function Connect-NYKeycloak()
{
    <#

    .SYNOPSIS
        Connect to Keycloak (Zerto) Server

    .DESCRIPTION
        Connect to Keycloak (Zerto) Server

    .PARAMETER BaseURL

    .PARAMETER ClientID

    .PARAMETER ClientSecret

    .NOTES
        Filename         : Connect-NYKeycloak
        Creation Date    : 02-17-2024
        Author           : Paschal Bekke
        Copyright        : (c) 2024 - Paschal Bekke
        Version          : 1.0
        
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position=0,mandatory=$true)][string]$BaseURL,
        [Parameter(Position=2,mandatory=$true)][string]$ClientID,
        [Parameter(Position=3,mandatory=$true)][string]$ClientSecret,
        [switch]$NoErrorMessage,
        [switch]$SkipCertificateCheck
    )
    
    begin{
        $IDS_SCRIPTNAME = "{0}" -f $MyInvocation.MyCommand                      # Get name of running function
        if($NoErrorMessage) { $ErrorActionPreference = 'silentlycontinue' }     # Disable error output

        Write-Verbose "Beginning of Connecting to Keycloak server"
        
        $authURL = $baseURL + "/auth/realms/zerto/protocol/openid-connect/token"
        $contentType = "application/x-www-form-urlencoded"
        $body="client_id=$ClientID&client_secret=$ClientSecret&grant_type=client_credentials"
    }
    process{
        Write-Verbose "Inside Processing Connecting to ...."
        $result = "" # initially empty
        try {
            Write-Verbose "Executing RestAPI Request..."
            $result = Invoke-RestMethod -Method POST -Uri $AuthURL -ContentType $contentType -Body $body -SkipCertificateCheck:$SkipCertificateCheck
        } 
        catch { 
            Write-Verbose "Error Occurred.. Exception will be transfered to Process-Error function.."
            DisplayProcess-Error -IDS_ORIGINATING_SCRIPTNAME $IDS_SCRIPTNAME -ErrorArray $_
        }
    }
    end{
        Write-Verbose "Rounding off, end of Connecting to Keycloak server"
        $token = $result
        return $token
    }
}