# .ExternalHelp IdentityCommand.SCA-help.xml
function Get-SCAOnDemandConfig {
    [CmdletBinding()]
    param()

    begin { }#begin

    process {

        $URI = "$(Resolve-RequestUrl)/api/on-demand/config"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result

        }

    }#process

    end { }#end

}
