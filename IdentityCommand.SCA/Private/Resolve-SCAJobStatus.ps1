function Resolve-SCAJobStatus {
    <#
    .SYNOPSIS
    Reports the status of the job started by an asynchronous request.

    .DESCRIPTION
    Some SCA operations are asynchronous, and their response carries nothing except the identifier of the
    job which was started. The commands calling those endpoints pass the response here, and the status of
    that job is returned in its place.

    The API is inconsistent about which field carries the identifier - 'jobId' from the policy endpoints,
    'job_id' from web app creation - so both are accepted.

    A response carrying neither field is returned unaltered, so a response which reports more than the job
    it started does not have that detail discarded.

    .PARAMETER Result
    The response from the asynchronous request.

    .EXAMPLE
    Invoke-IDRestMethod -Uri $URI -Method POST -Body $body | Resolve-SCAJobStatus

    .EXAMPLE
    Resolve-SCAJobStatus -Result $result
    #>
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [psobject]$Result
    )

    process {

        $JobId = $null
        $Fields = $Result.PSObject.Properties.Name

        foreach ($Field in 'jobId', 'job_id') {

            if (($Fields -contains $Field) -and (-not [string]::IsNullOrEmpty($Result.$Field))) {

                $JobId = $Result.$Field
                break

            }

        }

        if ([string]::IsNullOrEmpty($JobId)) {

            Write-Verbose 'Response contains no job identifier - returning it unaltered'
            return $Result

        }

        Get-SCAJobStatus -jobId $JobId

    }#process

}
