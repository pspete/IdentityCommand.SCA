# .ExternalHelp IdentityCommand.SCA-help.xml
function Test-SCAPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('policy_id')]
        [String]$policyId
    )

    begin { }#begin

    process {

        $URI = Add-SCAQueryString -URI "$($ISPSSSession.tenant_url)/api/policies/validate" -SupportsDebug

        #Create Request Body
        $body = ConvertTo-SCAJsonBody -Body @{ 'policyId' = $policyId }

        if ($PSCmdlet.ShouldProcess($policyId, 'Validate SCA Policy')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
