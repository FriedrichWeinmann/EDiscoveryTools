# Whether a Compliance Center connection has been established.
$script:connected = $false

# Whether the default configuration set for search filter creation has been imported yet
$script:defaultGroupMappingDataImported = $false

# Used for filtering searches in a convenient manner when creating cases
$script:searchGroupMappingData = @{ }