# .ExternalHelp IdentityCommand.SCA-help.xml
function Request-SCAAccess {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AWS', 'AZURE', 'GCP')]
        [String]$csp,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SCAAccessTargetDefinition.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Access.Target')]
        [psobject[]]$targets,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$organizationId
    )

    begin {

        $ExpectedProperties = @('organizationId', 'csp', 'targets')

    }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/access/elevate"

        #Project supplied parameters onto the expected request properties
        $Properties = Select-SCARequestProperty -Property $ExpectedProperties -BoundParameter ($PSBoundParameters | Get-Parameter)

        #Create Request Body
        $body = ConvertTo-SCAJsonBody -Body $Properties

        if ($PSCmdlet.ShouldProcess("$csp targets", 'Elevate Access')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result.response

            }

        }

    }#process

    end { }#end

}
