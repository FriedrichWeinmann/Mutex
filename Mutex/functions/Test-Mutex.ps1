﻿function Test-Mutex {
    <#
    .SYNOPSIS
        Check if a mutex has been already used in another process.

    .DESCRIPTION
        Check if a mutex has been already used in another process.
        This method can only check if a mutex by agiven name has been initialized in another process.
        It does not check if the mutex is currently been locked.

    .PARAMETER Name
        Name of the mutex to acquire a lock on. If the mutex should be globally valid on a multi user system
        prefix the name with "Global\". Otherwise it is assumed that it belongs only to the current
        user session (equals the prefix "Local\").

    .PARAMETER CheckIfLocked
        If used Test-Mutex will also check if an existing Mutex has been already locked.

    .EXAMPLE
        PS C:\> Test-Mutex -Name MyModule.LogFile

        Checks if the mutex 'MyModule.LogFile' has been created in another process.

    .EXAMPLE
        PS C:\> Test-Mutex -Name MyModule.LogFile -CheckIfLocked

        Checks if the mutex 'MyModule.LogFile' has been created in another process and if it's locked.
        Returns $false if it does not exist or if it's currently not locked.
        Therefor: $false means you can use it/the corresponding ressource.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Name,
        [switch]
        $CheckIfLocked
    )

    process {
            $existingMutex = $null
            if (-not [System.Threading.Mutex]::TryOpenExisting($Name, [ref]$existingMutex)) {
                return $false
            }
            if ($CheckIfLocked) {
                $canItBeLocked = $existingMutex.WaitOne(5)
                if ($canItBeLocked) { $existingMutex.ReleaseMutex() }
                return (-not $canItBeLocked)
            }
            return $true
    }
}