# .ExternalHelp IdentityCommand.SCA-help.xml
function New-SCAScanEntityDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function does not change state')]
    [OutputType('IdCmd.SCA.Definition.Scan.EntityId')]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$account_id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$org_id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $false,
            HelpMessage = 'Accepts previous output from New-SCAScanEntityDefinition, to which this entity is appended.'
        )]
        [PSTypeName('IdCmd.SCA.Definition.Scan.EntityId')]
        [psobject[]]$Definition
    )

    begin {

        $ExpectedProperties = @('org_id', 'account_id')

    }#begin

    process {

        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove Definition

        $Entity = Select-SCARequestProperty -Property $ExpectedProperties -BoundParameter $boundParameters

        if ($PSBoundParameters.ContainsKey('Definition')) { $Definition }

        $Entity | Add-CustomType -Type IdCmd.SCA.Definition.Scan.EntityId

    }#process

    end { }#end

}
