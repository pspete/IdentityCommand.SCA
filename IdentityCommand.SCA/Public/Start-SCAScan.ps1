# .ExternalHelp IdentityCommand.SCA-help.xml
function Start-SCAScan {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AWS', 'GCP', 'AZURE')]
        [String]$cloudProvider,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('All', 'Specific')]
        [String]$accountType,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SCAScanEntityDefinition.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Scan.EntityId')]
        [psobject[]]$entityIds
    )

    begin {

        $ExpectedProperties = @('cloudProvider', 'accountType', 'entityIds')

    }#begin

    process {

        $URI = Add-SCAQueryString -URI "$($ISPSSSession.tenant_url)/api/cloud/rescan" -SupportsDebug

        $boundParameters = $PSBoundParameters | Get-Parameter

        #The API expects the numeric value of the cloud provider
        $boundParameters['cloudProvider'] = ConvertTo-SCAApiValue -Name CloudProvider -Value $cloudProvider

        #Project supplied parameters onto the expected request properties
        $Properties = Select-SCARequestProperty -Property $ExpectedProperties -BoundParameter $boundParameters

        #Create Request Body
        $body = ConvertTo-SCAJsonBody -Body $Properties

        if ($PSCmdlet.ShouldProcess("$cloudProvider ($accountType)", 'Start SCA Cloud Scan')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
