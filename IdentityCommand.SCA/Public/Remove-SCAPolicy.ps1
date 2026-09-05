# .ExternalHelp IdentityCommand.SCA-help.xml
function Remove-SCAPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('policyId')]
        [String]$policy_id
    )

    begin { }#begin

    process {

        $URI = Add-SCAQueryString -URI "$($ISPSSSession.tenant_url)/api/policies/$policy_id" -SupportsDebug

        if ($PSCmdlet.ShouldProcess($policy_id, 'Remove SCA Policy')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method DELETE -Headers $(Get-SCAPolicyApiHeader)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
