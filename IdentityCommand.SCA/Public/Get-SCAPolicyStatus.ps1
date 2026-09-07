# .ExternalHelp IdentityCommand.SCA-help.xml
function Get-SCAPolicyStatus {
    [CmdletBinding()]
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

        #The API defines policy_id as both a path and a query parameter for this operation
        $URI = Add-QueryString -URI "$($ISPSSSession.tenant_url)/api/policies/$policy_id/status" -Parameter @{ 'policy_id' = $policy_id }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            #The API returns the status as a bare integer - report what it means alongside it
            $Status = ConvertFrom-SCAApiValue -Name PolicyStatus -Value $result

            [pscustomobject]@{
                policyId    = $policy_id
                status      = $Status.Value
                statusName  = $Status.Name
                description = $Status.Description
            } | Add-CustomType -Type IdCmd.SCA.Policy.Status

        }

    }#process

    end { }#end

}
