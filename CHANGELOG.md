# Change Log

All notable changes to this project will be documented in this file.

## Unreleased

### Added

- Initial command set for the CyberArk/Idira **Secure Cloud Access** API.
- Session: `Connect-SCATenant` (existing `IdentityCommand` session, or `-Credential` / `-Credential -PlatformToken` / `-SAMLResponse` authentication with URL discovery from a subdomain or tenant url), `Get-SCAModuleData`.
- Policies: `Get-SCAPolicy`, `New-SCAPolicy`, `Set-SCAPolicy`, `Remove-SCAPolicy`, `Get-SCAPolicyStatus`, `Test-SCAPolicy`, `Start-SCADiscovery`. Version 2.0 of the Policies API is used throughout.
- Policy and request definition helpers: `New-SCAPolicyRoleDefinition`, `New-SCAPolicyIdentityDefinition`, `New-SCAPolicyAccessRuleDefinition`, `New-SCAAccessTargetDefinition`, `New-SCAScanEntityDefinition`. The role, identity, target and entity helpers accept a previous definition, so several can be chained onto one another.
- Access: `Get-SCAEligibleTarget`, `Get-SCAEligibleGroup`, `Request-SCAAccess`, `Request-SCAGroupMembership`, `Get-SCASession`, `Revoke-SCASession`. List results are automatically paginated - every page is returned.
- Cloud scan, jobs and onboarding: `Start-SCAScan`, `Get-SCAJobStatus`, `New-SCAWebApp`.
- On-demand approvals: `Get-SCAOnDemandConfig`, `Set-SCAOnDemandConfig`.
- `Get-SCAPolicyStatus` returns the status integer reported by the API alongside its name and meaning (1 Active, 3 Expired, 4 Error, 6 Validating), as an `IdCmd.SCA.Policy.Status` object.
- Tab-completion for policy and session id parameters.
- Commands which call an endpoint supporting the API's `debug` query parameter send `debug=true` when run with `-Debug`, returning the API's extended troubleshooting detail on an error.
- Friendly values are accepted where the API expects a numeric enumeration - `-status` (`Active`, `Expired`, `Error`, `Validating`) and `-cloud_provider` / `-cloudProvider` (`AWS`, `GCP`, `AZURE`, `AWS_IDC`, `AZURE_ENTRA_ID`).
