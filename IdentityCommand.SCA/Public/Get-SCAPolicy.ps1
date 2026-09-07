# .ExternalHelp IdentityCommand.SCA-help.xml
function Get-SCAPolicy {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ById'
        )]
        [Alias('policyId')]
        [String]$policy_id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [ValidateSet('Active', 'Expired', 'Error', 'Validating')]
        [String]$status,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [String]$free_text,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'List'
        )]
        [ValidateSet('AWS', 'GCP', 'AZURE', 'AWS_IDC', 'AZURE_ENTRA_ID')]
        [String]$cloud_provider
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/policies"

        if ($PSCmdlet.ParameterSetName -eq 'ById') {

            $URI = Add-QueryString -URI "$URI/$policy_id" -SupportsDebug

        } else {

            $boundParameters = $PSBoundParameters | Get-Parameter

            #The API filters on the numeric value of these fields
            if ($PSBoundParameters.ContainsKey('status')) {
                $boundParameters['status'] = ConvertTo-SCAApiValue -Name PolicyStatus -Value $status
            }

            if ($PSBoundParameters.ContainsKey('cloud_provider')) {
                $boundParameters['cloud_provider'] = ConvertTo-SCAApiValue -Name CloudProvider -Value $cloud_provider
            }

            $URI = Add-QueryString -URI $URI -Parameter $boundParameters -SupportsDebug

        }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET -Headers $(Get-SCAPolicyApiHeader)

        if ($null -ne $result) {

            if ($PSCmdlet.ParameterSetName -eq 'ById') { $result }
            else { $result.hits }

        }

    }#process

    end { }#end

}
