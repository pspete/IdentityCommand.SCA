# .ExternalHelp IdentityCommand.SCA-help.xml
function New-SCAPolicyIdentityDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function does not change state')]
    [OutputType('IdCmd.SCA.Definition.Policy.Identity')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$entityName,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$entitySourceId,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('user', 'role', 'group')]
        [String]$entityClass,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $false,
            HelpMessage = 'Accepts previous output from New-SCAPolicyIdentityDefinition, to which this identity is appended.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Policy.Identity')]
        [psobject[]]$Definition
    )

    begin {

        $ExpectedProperties = @('entityName', 'entitySourceId', 'entityClass')

    }#begin

    process {

        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove Definition

        $Identity = Select-SCARequestProperty -Property $ExpectedProperties -BoundParameter $boundParameters

        if ($PSBoundParameters.ContainsKey('Definition')) { $Definition }

        $Identity | Add-CustomType -Type IdCmd.SCA.Definition.Policy.Identity

    }#process

    end { }#end

}
