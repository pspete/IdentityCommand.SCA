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
        $Properties = Select-RequestProperty -Property @('appType', 'appName') -BoundParameter $boundParameters
        $Properties['appMetadata'] = Select-RequestProperty -Property @('workspaceId', 'establishAutoTrust', 'useIdentityAsIdp') -BoundParameter $boundParameters

        #Create Request Body
        $body = ConvertTo-JsonBody -Body $Properties

        if ($PSCmdlet.ShouldProcess($appName, 'Create SCA Web App')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                #Report the status of the job started by the request
                $result | Resolve-SCAJobStatus

            }

        }

    }#process

    end { }#end

}
