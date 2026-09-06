# .ExternalHelp IdentityCommand.SCA-help.xml
function New-SCAPolicy {
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
        [ValidateLength(1, 200)]
        [ValidateScript({ Test-SCAPolicyText -Value $PSItem -ParameterName name -Pattern $(Get-SCAPolicyTextPattern -Name Name) })]
        [String]$name,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(0, 200)]
        [ValidateScript({ Test-SCAPolicyText -Value $PSItem -ParameterName description -Pattern $(Get-SCAPolicyTextPattern -Name Description) })]
        [String]$description,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [datetime]$startDate,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [datetime]$endDate,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SCAPolicyRoleDefinition.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Policy.Role')]
        [psobject[]]$roles,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SCAPolicyIdentityDefinition.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Policy.Identity')]
        [psobject[]]$identities,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SCAPolicyAccessRuleDefinition.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Policy.AccessRule')]
        [psobject]$accessRules
    )

    begin {

        $ExpectedProperties = @('csp', 'name', 'description', 'startDate', 'endDate', 'roles', 'identities', 'accessRules')

    }#begin

    process {

        $URI = Add-SCAQueryString -URI "$($ISPSSSession.tenant_url)/api/policies/create-policy" -SupportsDebug

        #Get request parameters
        $boundParameters = $PSBoundParameters | Get-Parameter

        #The API expects ISO format dates
        foreach ($dateParam in 'startDate', 'endDate') {
            if ($PSBoundParameters.ContainsKey($dateParam)) {
                $boundParameters[$dateParam] = ConvertTo-SCADateString -Date $PSBoundParameters[$dateParam]
            }
        }

        #Project supplied parameters onto the expected request properties
        $Properties = Select-SCARequestProperty -Property $ExpectedProperties -BoundParameter $boundParameters

        #Create Request Body
        $body = ConvertTo-SCAJsonBody -Body $Properties

        if ($PSCmdlet.ShouldProcess($name, 'Create New SCA Policy')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body -Headers $(Get-SCAPolicyApiHeader)

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
