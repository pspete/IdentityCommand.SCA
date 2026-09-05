# .ExternalHelp IdentityCommand.SCA-help.xml
function Get-SCAEligibleTarget {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AWS', 'AZURE', 'GCP')]
        [String]$csp,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateRange(1, 100)]
        [int]$limit
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/access/$csp/eligibility"

        $URI = Add-SCAQueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter -ParametersToRemove csp)

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            Get-SCAPagedResult -InitialResult $result -URI $URI

        }

    }#process

    end { }#end

}
