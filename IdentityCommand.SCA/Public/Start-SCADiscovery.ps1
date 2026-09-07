# .ExternalHelp IdentityCommand.SCA-help.xml
function Start-SCADiscovery {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AWS', 'GCP', 'AZURE')]
        [String]$csp,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$organization_id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [bool]$new_account
    )

    begin { }#begin

    process {

        $URI = Add-QueryString -URI "$($ISPSSSession.tenant_url)/api/policies/discovery" -SupportsDebug

        $boundParameters = $PSBoundParameters | Get-Parameter

        #The workspace to discover is sent as a nested account_info object
        $Properties = Select-RequestProperty -Property @('csp', 'organization_id') -BoundParameter $boundParameters
        $Properties['account_info'] = Select-RequestProperty -Property @('id', 'new_account') -BoundParameter $boundParameters

        #Create Request Body
        $body = ConvertTo-JsonBody -Body $Properties

        if ($PSCmdlet.ShouldProcess($id, 'Start SCA Workspace Discovery')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
