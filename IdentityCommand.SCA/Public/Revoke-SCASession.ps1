# .ExternalHelp IdentityCommand.SCA-help.xml
function Revoke-SCASession {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'BySessionId')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'BySessionId'
        )]
        [Alias('sessionId')]
        [String[]]$sessionIds,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ByUser'
        )]
        [String]$userId
    )

    begin { }#begin

    process {

        if ($PSCmdlet.ParameterSetName -eq 'ByUser') {

            $URI = "$($ISPSSSession.tenant_url)/api/access/users/$userId/sessions/revoke"
            $Target = $userId
            $body = $null

        } else {

            $URI = "$($ISPSSSession.tenant_url)/api/access/sessions/revoke"
            $Target = $sessionIds -join ', '

            #Create Request Body
            $body = ConvertTo-SCAJsonBody -Body @{ 'sessionIds' = @($sessionIds) }

        }

        if ($PSCmdlet.ShouldProcess($Target, 'Revoke SCA Session')) {

            #Send Request
            $result = if ($null -eq $body) {
                Invoke-IDRestMethod -Uri $URI -Method POST
            } else {
                Invoke-IDRestMethod -Uri $URI -Method POST -Body $body
            }

            if ($null -ne $result) {

                $result.response

            }

        }

    }#process

    end { }#end

}
