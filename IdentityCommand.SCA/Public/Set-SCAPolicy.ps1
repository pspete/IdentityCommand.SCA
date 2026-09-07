# .ExternalHelp IdentityCommand.SCA-help.xml
function Set-SCAPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('policyId')]
        [String]$policy_id,

        [parameter(
            Mandatory = $false,
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
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            HelpMessage = 'Accepts object output from New-SCAPolicyRoleDefinition.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Policy.Role')]
        [psobject[]]$roles,

        [parameter(
            Mandatory = $false,
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

        $OrderedProperties = [ordered]@{
            'name'        = $null
            'description' = $null
            'startDate'   = $null
            'endDate'     = $null
            'roles'       = @()
            'identities'  = @()
            'accessRules' = $null
        }

    }#begin

    process {

        $URI = Add-SCAQueryString -URI "$($ISPSSSession.tenant_url)/api/policies/$policy_id" -SupportsDebug

        #Get existing policy settings
        $PolicySettings = Get-SCAPolicy -policy_id $policy_id

        #Get request parameters
        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove policy_id

        #The API expects ISO format dates
        foreach ($dateParam in 'startDate', 'endDate') {
            if ($PSBoundParameters.ContainsKey($dateParam)) {
                $boundParameters[$dateParam] = ConvertTo-SCADateString -Date $PSBoundParameters[$dateParam]
            }
        }

        #Project supplied parameters onto the request template, falling back to the existing policy
        $Properties = Merge-SCAParameter -Template $OrderedProperties -BoundParameter $boundParameters -Fallback $PolicySettings

        #Create Request Body
        $body = ConvertTo-SCAJsonBody -Body $Properties

        if ($PSCmdlet.ShouldProcess($policy_id, 'Update SCA Policy')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method PUT -Body $body -Headers $(Get-SCAPolicyApiHeader)

            if ($null -ne $result) {

                #Report the status of the job started by the request
                $result | Resolve-SCAJobStatus

            }

        }

    }#process

    end { }#end

}
