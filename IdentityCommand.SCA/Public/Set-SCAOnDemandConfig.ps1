# .ExternalHelp IdentityCommand.SCA-help.xml
function Set-SCAOnDemandConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('In-platform', 'External')]
        [String]$ApprovalChannel
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/on-demand/config"

        #Create Request Body
        $body = ConvertTo-SCAJsonBody -Body ($PSBoundParameters | Get-Parameter)

        if ($PSCmdlet.ShouldProcess($ApprovalChannel, 'Set SCA On-Demand Approval Channel')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method PATCH -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
