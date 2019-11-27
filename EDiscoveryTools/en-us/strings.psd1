# This is where the strings go, that are written by
# Write-PSFMessage, Stop-PSFFunction or the PSFramework validation scriptblocks
@{
	'Connect-EDiscovery.Config.NoSearchPath'		   = 'No default tag import has been configured yet. Consider specifying a default file using Register-EDisSearchTag.' # 
	'Connect-EDiscovery.Connecting'				       = 'Connecting to the Office 365 Compliance Center' # 
	
	'Import-EDisSearchTag.DefaultImport.Failed'	       = 'Failed to import configuration from {0}' # $importPath
	'Import-EDisSearchTag.DefaultImport.NoConfig'	   = 'No default tag import has been configured yet. Consider specifying a default file using Register-EDisSearchTag.' # 
	'Import-EDisSearchTag.DefaultImport.PathNotExists' = 'The specified default path could not be found: {0}. Verify that the configured path is correct.' # $importPath
	
	'New-EDisCase.AdvancedSearch.NotSupported'	       = 'Managing Advanced eDiscovery via PowerShell is not yet supported, adding searches to cases is not yet possible.' # 
	'New-EDisCase.Case.Create'					       = 'Creating case' # 
	
	#'New-EDisSearch.Execute'						   = 'Creating search for {0}' # $Case
	'New-EDisSearch.Tag.Invalid'					   = 'Invalid tag: {0}' # $tag
	
	'Validate.Path.Failed'							   = 'Failed to validate path: {0}' # <user input>, <validation item>
}