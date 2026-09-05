# .ExternalHelp IdentityCommand.SCA-help.xml
function Get-SCAJobStatus {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('job_id')]
        [String]$jobId
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/integrations/status"

        $URI = Add-SCAQueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter) -SupportsDebug

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result

        }

    }#process

    end { }#end

}
