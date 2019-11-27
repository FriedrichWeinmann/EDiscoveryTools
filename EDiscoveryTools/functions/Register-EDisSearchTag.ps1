function Register-EDisSearchTag
{
<#
	.SYNOPSIS
		Registers the path to a mappings file containing the mapping for simplified search creation.
	
	.DESCRIPTION
		Registers the path to a mappings file containing the mapping for simplified search creation.
	
		During New-EDisCase, the tags specified in the configuration file will be offered as tab completion.
		The group addresses registered behind it will be used for scoping the search filter.
	
		Supported formats:
		CSV:  A two column table: Tag | Group
		      To assign multible groups to the same tag, add multiple entries for the same tag.
		      The csv should be delimited by a comma.
		Json: The Json file should be one hashtable, using the Key as Key and a list of group email addresses as values.
		XML:  The XML file should be structured thus:
		<entries>
		  <entry>
		    <tag>ExampleName</tag>
		    <group>example@domain.com</group>
		  </entry>
		  <entry>
		    <tag>ExampleName2</tag>
		    <group>example2@domain.com</group>
		  </entry>
		</entries>
		Multiple groups mapped to the same tag get multiple entries anyway, similar to the csv type.
	
		All input files are expected to be UTF8 with or without BOM.
	
	.PARAMETER Path
		Path to the file to be registered.
	
	.PARAMETER Type
		Type of the input file to be registered
	
	.EXAMPLE
		PS C:\> Register-EDisSearchTag -Path '\\server\share\EDiscoverySearchMapping.csv'
	
		Registers the EDiscoverySearchMapping.csv file as input file for label mapping.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[PsfValidateScript('EDiscovery.Validate.Path', ErrorString = 'EDiscovery.Validate.Path.Failed')]
		[string]
		$Path,
		
		[ValidateSet('csv','json','xml')]
		[string]
		$Type = 'csv'
	)
	
	process
	{
		$resolvedPath = Resolve-PSFPath -Path $Path -Provider FileSystem -SingleItem
		Set-PSFConfig -Module 'EDiscoveryTools' -Name 'Search.Config.Path' -Value $resolvedPath -PassThru | Register-PSFConfig
		Set-PSFConfig -Module 'EDiscoveryTools' -Name 'Search.Config.Type' -Value $Type -PassThru | Register-PSFConfig
	}
}