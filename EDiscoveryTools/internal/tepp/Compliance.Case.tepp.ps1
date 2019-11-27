Register-PSFTeppScriptblock -Name 'Compliance.Case.Name' -ScriptBlock {
	if ($fakeBoundParameters.CaseType)
	{
		(Get-ComplianceCase -CaseType $fakeBoundParameters.CaseType).Name
	}
	else { (Get-ComplianceCase).Name }
}
Register-PSFTeppArgumentCompleter -Command Get-ComplianceCase -Parameter Identity -Name 'Compliance.Case.Name'
Register-PSFTeppArgumentCompleter -Command New-EDisSearch -Parameter Case -Name 'Compliance.Case.Name'

Register-PSFTeppScriptblock -Name 'Compliance.Case.Type' -ScriptBlock {
	'eDiscovery', 'DSR', 'ComplianceWorkspace', 'AdvancedEdiscovery', 'DataInvestigation', 'InternalInvestigation', 'ComplianceClassifier', 'SupervisionPolicy', 'InsiderRisk'
}
Register-PSFTeppArgumentCompleter -Command Get-ComplianceCase -Parameter CaseType -Name 'Compliance.Case.Type'
Register-PSFTeppArgumentCompleter -Command New-ComplianceCase -Parameter CaseType -Name 'Compliance.Case.Type'
