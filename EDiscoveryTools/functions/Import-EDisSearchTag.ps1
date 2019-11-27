function Import-EDisSearchTag
{
<#
	.SYNOPSIS
		Imports a name mapping file used for creating searches.
	
	.DESCRIPTION
		Imports a name mapping file used for creating searches.
		See Register-EDisSearchTag for details on format of input.
		Imports the configured default config if no path is specified.
	
	.PARAMETER Path
		Path to a configuration file to import.
		If this parameter is omitted, the default configured file specified through Register-EDisSearchTag is used instead.
	
	.PARAMETER Type
		The type of file specified.
		If not specified, it will try to use the file extension to determine type.
		If that too fails, it will default to csv.
	
	.PARAMETER EnableException
		This parameters disables user-friendly warnings and enables the throwing of exceptions.
		This is less user friendly, but allows catching exceptions in calling scripts.
	
	.EXAMPLE
		PS C:\> Import-EDisSearchTag
	
		Imports the default search group mapping.
	
	.EXAMPLE
		PS C:\> Import-EDisSearchTag -Path .\config.json
	
		Imports the search group mapping stored in config.json.
#>
	[CmdletBinding()]
	Param (
		[PsfValidateScript('EDiscovery.Validate.Path', ErrorString = 'EDiscovery.Validate.Path.Failed')]
		[string]
		$Path,
		
		[ValidateSet('csv', 'json', 'xml')]
		[string]
		$Type,
		
		[switch]
		$EnableException
	)
	
	begin
	{
		function Import-CsvConfig
		{
			[CmdletBinding()]
			param (
				[string]
				$Path
			)
			foreach ($entry in (Import-Csv -Path $Path -Delimiter "," -Encoding UTF8 -ErrorAction Stop))
			{
				if (-not ($entry.Tag -and $entry.Group)) { throw "Invalid CSV file!" }
				
				if ($script:searchGroupMappingData[$entry.Tag])
				{
					$script:searchGroupMappingData[$entry.Tag] = $script:searchGroupMappingData[$entry.Tag], $entry.Group | Write-Output | Select-Object -Unique
				}
				else
				{
					$script:searchGroupMappingData[$entry.Tag] = $entry.Group
				}
			}
		}
		function Import-JsonConfig
		{
			[CmdletBinding()]
			param (
				[string]
				$Path
			)
			$data = Get-Content -Path $Path -Encoding UTF8 -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
			foreach ($entry in ($data.PSObject.Properties.Name))
			{
				if (-not $data.$entry) { throw "Invalid json file!" }
				
				if ($script:searchGroupMappingData[$entry])
				{
					$script:searchGroupMappingData[$entry] = $script:searchGroupMappingData[$entry], $data.$entry | Write-Output | Select-Object -Unique
				}
				else
				{
					$script:searchGroupMappingData[$entry] = $data.$entry
				}
			}
		}
		function Import-XmlConfig
		{
			[CmdletBinding()]
			param (
				[string]
				$Path
			)
			[xml]$data = Get-Content -Path $Path -Encoding UTF8 -ErrorAction Stop
			if (-not $data.entries.entry) { throw "Invalid XML configuration file!" }
			
			foreach ($entry in $xml.entries.entry)
			{
				if (-not ($entry.Tag -and $entry.Group)) { throw "Invalid XML configuration entry!" }
				
				if ($script:searchGroupMappingData[$entry.Tag])
				{
					$script:searchGroupMappingData[$entry.Tag] = $script:searchGroupMappingData[$entry.Tag], $entry.Group | Write-Output | Select-Object -Unique
				}
				else
				{
					$script:searchGroupMappingData[$entry.Tag] = $entry.Group
				}
			}
		}
	}
	process
	{
		if ($Path)
		{
			$importPath = Resolve-PSFPath -Path $Path -Provider FileSystem -SingleItem
			$selectedType = $Type
			if (Test-PSFParameterBinding -ParameterName Type -Not)
			{
				$item = Get-Item -LiteralPath $importPath
				switch ($item.Extension)
				{
					'.Json' { $selectedType = 'Json' }
					'.Xml' { $selectedType = 'Xml' }
					default { $selectedType = 'Csv' }
				}
			}
			try
			{
				switch ($selectedType)
				{
					'Json' { Import-JsonConfig -Path $importPath }
					'Xml' { Import-XmlConfig -Path $importPath }
					default { Import-CsvConfig -Path $importPath }
				}
			}
			catch
			{
				Stop-PSFFunction -String Import-EDisSearchTag.DefaultImport.Failed -StringValues $importPath -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
				return
			}
		}
		else
		{
			$importPath = Get-PSFConfigValue -FullName 'EDiscoveryTools.Search.Config.Path'
			if (-not $importPath)
			{
				Stop-PSFFunction -String Import-EDisSearchTag.DefaultImport.NoConfig -EnableException $EnableException -Cmdlet $PSCmdlet
				return
			}
			if (-not (Test-Path $importPath))
			{
				Stop-PSFFunction -String Import-EDisSearchTag.DefaultImport.PathNotExists -StringValues $importPath -EnableException $EnableException -Cmdlet $PSCmdlet
				return
			}
			
			try
			{
				switch (Get-PSFConfigValue -FullName 'EDiscoveryTools.Search.Config.Type')
				{
					'Json' { Import-JsonConfig -Path $importPath }
					'Xml' { Import-XmlConfig -Path $importPath }
					default { Import-CsvConfig -Path $importPath }
				}
				$script:defaultGroupMappingDataImported = $true
			}
			catch
			{
				Stop-PSFFunction -String Import-EDisSearchTag.DefaultImport.Failed -StringValues $importPath -EnableException $EnableException -Cmdlet $PSCmdlet -ErrorRecord $_
				return
			}
		}
	}
}