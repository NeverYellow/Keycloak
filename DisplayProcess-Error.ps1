function DisplayProcess-Error()
{
    # IDS Stands for : ID of Script
    [cmdletbinding()]
    param(
        [String]$IDS_ORIGINATING_SCRIPTNAME,
        [Array]$ErrorArray
    )
    
    $IDS_SCRIPTNAME = "{0}" -f $MyInvocation.MyCommand                      # Get name of running function

    $errorMessage          = $ErrorArray.Exception.Message
    $errorValue            = $ErrorArray.Exception.Statuscode.value__
    $failedItem            = $ErrorArray.Exception.ItemName
    $status                = $ErrorArray.Exception.Status
    $fullyQualifiedErrorId = $ErrorArray.FullyQualifiedErrorId
    $pSMessageDetails      = $ErrorArray.PSMessageDetails
    $categoryInfo          = $ErrorArray.CategoryInfo
    $exceptionFullName     = $ErrorArray.Exception.GetType().FullName

    Write-Verbose "  ================================== Start verbose output =================================================="
    Write-Verbose "  $IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : errorMessage          : $errorMessage"
    Write-Verbose "  $IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : errorValue            : $errorValue"
    Write-Verbose "  $IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : failedItem            : $failedItem"
    Write-Verbose "  $IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : status                : $status"
    Write-Verbose "  $IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : fullyQualifiedErrorId : $fullyQualifiedErrorId"
    Write-Verbose "  $IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : pSMessageDetails      : $pSMessageDetails"
    Write-Verbose "  $IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : categoryInfo          : $categoryInfo"
    Write-Verbose "  $IDS_SCRIPTNAME : ($IDS_ORIGINATING_SCRIPTNAME) : exceptionFullName     : $exceptionFullName"
    Write-Verbose "  ================================== End verbose output =================================================="

    $errorNumber = '001' # Undefined error
    if (![string]::IsNullOrEmpty($errorValue)) {
        Write-Verbose "ErrorValue does exist : [$errorValue]"
        $errorNumber = $errorValue
    } else {
        Write-Verbose "ErrorValue does not exist"
        if($errorMessage -like '*trust relationship for the SSL*') { $errorNumber = '002' }
        if($errorMessage -like '*The SSL connection could not be established*') { $errorNumber = '007' }
        if($fullyQualifiedErrorId -like '*ImportSecureString_InvalidArgument_CryptographicError*') { $errorNumber = '003' }
        if($errorMessage -Like '*Invalid URI:*') { $errorNumber = '004' }
        if($errorMessage -Like '*EmptyCommand*') { $errorNumber = '005' }
        if($errorMessage -Like '*EmptyRecord*') { $errorNumber = '006' }
    }
    
    switch($errorNumber) {
        '001' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : Error is not yet defined, ErrorMessage : $ErrorMessage"}
        '002' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : $ErrorMessage, Missing the Server Certificate `nuse the parameter -SkipCertificateCheck"}
        '003' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : Encrypted string not valid anymore, maybe it was created in another session, use Initialize-Module"}
        '004' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : Invalid URI: Most likely there is no connection to the Server or it is not yet configured"}
        '005' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : No command specified. Please enter a command, for a list of objects use Get-IBObjectSchema -GridSupportedObjects"}
        '006' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : No record specified. Please use a resource type like A, AAAA, CNAME, MX, PTR or some other resource type"}
        '007' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : The SSL connection could not be established, use a certificate for the API Server or use -SkipCertificateCheck"}
        '400' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : Bad Request, Request is most likely not complete, Use Get-Help $IDS_ORIGINATING_SCRIPTNAME -Examples or try with -Verbose parameter"}
        '401' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : Unauthorized, probably invalid credentials"}
        '403' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : SessionID not valid anymore, Timed out or some other reason, `nPlease use Connect-IBGridMaster to make a connection"}
        '500' { Write-Host "$IDS_ORIGINATING_SCRIPTNAME : Server Error or Internal Error, Try again or check Infoblox GridMaster"}
    }
    
}
