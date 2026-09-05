function Get-SCAPolicyApiHeader {
    <#
    .SYNOPSIS
    Returns the header which selects the version of the SCA Policies API to call.

    .DESCRIPTION
    The SCA Policies API exposes two request/response shapes, selected by the X-API-Version request
    header. This module works exclusively with version 2.0 - the version CyberArk recommends - so every
    policy command sends the same header, formed here.

    .EXAMPLE
    Invoke-IDRestMethod -Uri $URI -Method GET -Headers (Get-SCAPolicyApiHeader)
    #>
    [OutputType([hashtable])]
    [CmdletBinding()]
    param()

    @{ 'X-API-Version' = '2.0' }

}
