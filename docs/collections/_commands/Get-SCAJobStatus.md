---
external help file: IdentityCommand.SCA-help.xml
Module Name: IdentityCommand.SCA
online version:
schema: 2.0.0
---

# Get-SCAJobStatus

## SYNOPSIS
Gets the status of an SCA job

## SYNTAX

```
Get-SCAJobStatus [-jobId] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the status of a job created by an asynchronous operation, such as Start-SCAScan, Start-SCADiscovery, New-SCAPolicy or Test-SCAPolicy.

## EXAMPLES

### Example 1
```powershell
Get-SCAJobStatus -jobId 'e369baf0-1b24-11ee-be56-0242ac120002'
```

Gets the status of the specified job.

### Example 2
```powershell
Start-SCAScan -cloudProvider AWS -accountType All | Get-SCAJobStatus
```

Starts a scan and reports the status of the job it created.

## PARAMETERS

### -jobId
The ID of the job to report the status of, as returned by an asynchronous operation such as Start-SCAScan.

```yaml
Type: String
Parameter Sets: (All)
Aliases: job_id

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
