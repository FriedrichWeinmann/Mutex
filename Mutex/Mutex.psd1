@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'Mutex.psm1'

    # Version number of this module.
    ModuleVersion     = '1.1.6'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '32c6bce6-7bd3-4a41-9eb5-84bf48659573'

    # Author of this module
    Author            = 'Friedrich Weinmann'

    # Company or vendor of this module
    CompanyName       = 'Microsoft'

    # Copyright statement for this module
    Copyright         = '(c) Friedrich Weinmann. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Wrapper around the .NET Mutex tooling'



    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Get-Mutex'
        'Invoke-MutexCommand'
        'Lock-Mutex'
        'New-Mutex'
        'Remove-Mutex'
        'Set-MutexDefault'
        'Unlock-Mutex'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('mutex', 'synchronization')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/FriedrichWeinmann/Mutex/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/FriedrichWeinmann/Mutex'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/FriedrichWeinmann/Mutex/blob/master/Mutex/changelog.md'

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

