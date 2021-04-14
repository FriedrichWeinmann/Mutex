# Central list of all mutexes
$script:mutexes = @{ }

# Which permission should be used by default when creating a new mutex
# Maps the the -Access parameter of New-Mutex
$script:mutexDefaultAccess = 'default'

# Which default security object to apply when creating a new mutex
# Maps to the -Security parameter of New-Mutex
$script:mutexDefaultSecurity = $null