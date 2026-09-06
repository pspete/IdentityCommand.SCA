# .ExternalHelp IdentityCommand.SCA-help.xml
function Get-SCASession {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ByUser'
        )]
        [String]$userId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AWS', 'AZURE', 'GCP')]
        [String]$csp,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateRange(1, 50)]
        [int]$limit
    )

    begin { }#begin

    process {

        $URI = if ($PSCmdlet.ParameterSetName -eq 'ByUser') {
            "$($ISPSSSession.tenant_url)/api/access/users/$userId/sessions"
        } else {
            "$($ISPSSSession.tenant_url)/api/access/sessions"
        }

        $URI = Add-SCAQueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter -ParametersToRemove userId)

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            Get-SCAPagedResult -InitialResult $result -URI $URI

        }

    }#process

    end { }#end

}
