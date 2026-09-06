# .ExternalHelp IdentityCommand.SCA-help.xml
function New-SCAWebApp {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AWS IAM', 'AWS IdC', 'Azure', 'GCP')]
        [String]$appType,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$appName,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$workspaceId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [bool]$establishAutoTrust,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [bool]$useIdentityAsIdp
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/onboarding/apps"

        $boundParameters = $PSBoundParameters | Get-Parameter

        #The workspace details are sent as a nested appMetadata object
        $Properties = Select-SCARequestProperty -Property @('appType', 'appName') -BoundParameter $boundParameters
        $Properties['appMetadata'] = Select-SCARequestProperty -Property @('workspaceId', 'establishAutoTrust', 'useIdentityAsIdp') -BoundParameter $boundParameters

        #Create Request Body
        $body = ConvertTo-SCAJsonBody -Body $Properties

        if ($PSCmdlet.ShouldProcess($appName, 'Create SCA Web App')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
