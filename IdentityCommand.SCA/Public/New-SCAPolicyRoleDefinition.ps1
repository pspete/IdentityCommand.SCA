# .ExternalHelp IdentityCommand.SCA-help.xml
function New-SCAPolicyRoleDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function does not change state')]
    [OutputType('IdCmd.SCA.Definition.Policy.Role')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$entityId,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$entitySourceId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$workspaceType,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$organizationId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $false,
            HelpMessage = 'Accepts previous output from New-SCAPolicyRoleDefinition, to which this role is appended.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Policy.Role')]
        [psobject[]]$Definition
    )

    begin {

        $ExpectedProperties = @('entityId', 'workspaceType', 'entitySourceId', 'organizationId')

    }#begin

    process {

        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove Definition

        $Role = Select-SCARequestProperty -Property $ExpectedProperties -BoundParameter $boundParameters

        if ($PSBoundParameters.ContainsKey('Definition')) { $Definition }

        $Role | Add-CustomType -Type IdCmd.SCA.Definition.Policy.Role

    }#process

    end { }#end

}
