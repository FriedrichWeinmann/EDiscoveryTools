Register-PSFTeppScriptblock -Name "Compliance.Search.Tag" -ScriptBlock {
	$module = Get-Module EDiscoveryTools
	& $module { $script:searchGroupMappingData.Keys }
}
Register-PSFTeppArgumentCompleter -Command New-EDisSearch -Parameter SearchTag -Name "Compliance.Search.Tag"
Register-PSFTeppArgumentCompleter -Command New-EDisCase -Parameter SearchTag -Name "Compliance.Search.Tag"