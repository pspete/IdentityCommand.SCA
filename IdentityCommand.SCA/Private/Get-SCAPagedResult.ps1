function Get-SCAPagedResult {
    <#
    .SYNOPSIS
    Follows SCA API pagination and returns the combined result set.

    .DESCRIPTION
    The SCA list endpoints (access eligibility, eligible groups, and active sessions) return their items
    under a 'response' property alongside a 'nextToken' continuation token. The token is sent back
    verbatim as the 'nextToken' query parameter to request the following page, until it comes back
    null or empty.

    This helper performs that walk and returns every item across all pages.

    .PARAMETER InitialResult
    The already-fetched first page of results.

    .PARAMETER URI
    The URI used for the initial request. Subsequent pages are requested against this URI with the
    continuation token appended, so any filter query parameters already present are preserved.

    .PARAMETER ResultProperty
    The property on the response holding the array of items. Defaults to 'response'.

    .PARAMETER CursorRequestKey
    Query parameter name the continuation token is sent back as. Defaults to 'nextToken'.

    .PARAMETER CursorResponseKey
    Property on the response holding the next continuation token. Defaults to 'nextToken'.

    .EXAMPLE
    Get-SCAPagedResult -InitialResult $result -URI $URI

    .INPUTS
    None. InitialResult is not accepted from the pipeline - a bare-array API response would otherwise
    be split into one call per element instead of a single call with the whole array.

    .OUTPUTS
    All items across all pages.
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'ResultProperty', Justification = 'Used inside the GetItems scriptblock')]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        $InitialResult,

        [parameter(Mandatory = $true)]
        [string]$URI,

        [parameter(Mandatory = $false)]
        [string]$ResultProperty = 'response',

        [parameter(Mandatory = $false)]
        [string]$CursorRequestKey = 'nextToken',

        [parameter(Mandatory = $false)]
        [string]$CursorResponseKey = 'nextToken'
    )

    process {

        #Local helper to pull the item array out of a page, whether it's wrapped in a property or a bare array
        $GetItems = {
            param($PageResult)
            if ($ResultProperty) { $PageResult.$ResultProperty } else { $PageResult }
        }

        $Items = [Collections.Generic.List[Object]]::New()

        $InitialItems = & $GetItems $InitialResult
        if ($null -ne $InitialItems) {
            $null = $Items.AddRange(@($InitialItems))
        }

        $NextToken = $InitialResult.$CursorResponseKey

        while (-not [String]::IsNullOrEmpty($NextToken)) {

            $PageURI = Add-SCAQueryString -URI $URI -Parameter @{ $CursorRequestKey = $NextToken }

            $PageResult = Invoke-IDRestMethod -Uri $PageURI -Method GET
            $PageItems = & $GetItems $PageResult

            if (($null -eq $PageItems) -or (@($PageItems).Count -eq 0)) {
                break
            }

            $null = $Items.AddRange(@($PageItems))
            $NextToken = $PageResult.$CursorResponseKey

        }

        $Items

    }#process

}
