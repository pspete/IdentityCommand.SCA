# .ExternalHelp IdentityCommand.SCA-help.xml
function Get-SCAEligibleGroup {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AZURE')]
        [String]$csp = 'AZURE',

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateRange(1, 100)]
        [int]$limit
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/access/$csp/eligibility/groups"

        $URI = Add-SCAQueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter -ParametersToRemove csp)

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            Get-SCAPagedResult -InitialResult $result -URI $URI

        }

    }#process

    end { }#end

}
