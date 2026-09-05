# .ExternalHelp IdentityCommand.SCA-help.xml
function Request-SCAGroupMembership {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String]$directoryId,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [String[]]$groupId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AZURE')]
        [String]$csp = 'AZURE'
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/access/elevate/groups"

        $Properties = [ordered]@{
            'directoryId' = $directoryId
            'csp'         = $csp
            'targets'     = @($groupId | ForEach-Object { @{ 'groupId' = $PSItem } })
        }

        #Create Request Body
        $body = ConvertTo-SCAJsonBody -Body $Properties

        if ($PSCmdlet.ShouldProcess($($groupId -join ', '), 'Request Just-In-Time Group Membership')) {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

            if ($null -ne $result) {

                $result

            }

        }

    }#process

    end { }#end

}
