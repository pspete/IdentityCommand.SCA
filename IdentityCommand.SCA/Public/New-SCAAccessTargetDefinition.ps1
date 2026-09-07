# .ExternalHelp IdentityCommand.SCA-help.xml
function New-SCAAccessTargetDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function does not change state')]
    [OutputType('IdCmd.SCA.Definition.Access.Target')]
    [CmdletBinding(DefaultParameterSetName = 'ByRoleId')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ByRoleId'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ByRoleName'
        )]
        [String]$workspaceId,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ByRoleId'
        )]
        [String]$roleId,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ByRoleName'
        )]
        [String]$roleName,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $false,
            HelpMessage = 'Accepts previous output from New-SCAAccessTargetDefinition, to which this target is appended.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Access.Target')]
        [psobject[]]$Definition
    )

    begin {

        $ExpectedProperties = @('workspaceId', 'roleId', 'roleName')

    }#begin

    process {

        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove Definition

        $Target = Select-RequestProperty -Property $ExpectedProperties -BoundParameter $boundParameters

        if ($PSBoundParameters.ContainsKey('Definition')) { $Definition }

        $Target | Add-CustomType -Type IdCmd.SCA.Definition.Access.Target

    }#process

    end { }#end

}
