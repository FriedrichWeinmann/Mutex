function Unlock-Mutex {
    <#
    .SYNOPSIS
        Release the lock on a mutex you manage.

    .DESCRIPTION
        Release the lock on a mutex you manage.
        Will silently return if the mutex does not exist.

    .PARAMETER Name
        The name of the mutex to release the lock on.

    .PARAMETER Force
        If set the mutex will be released as often as needed to reach the LockCount of 0.

    .EXAMPLE
        PS C:\> Unlock-Mutex -Name MyModule.LogFile

        Release the lock on the mutex 'MyModule.LogFile'

    .EXAMPLE
        PS C:\> Get-Mutex | Release-Mutex

        Release the lock on all mutexes managed.

    .EXAMPLE
        PS C:\> Get-Mutex | Release-Mutex -Force

        Release the lock on all mutexes managed regardless how often they have been locked in the process.

    .NOTES
        If using -Force the mutex will be released until a
        MethodInvocationException is thrown. This happens if the mutex has
        been already released.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Name,
        [switch]
        $Force
    )

    process {
        foreach ($mutexName in $Name) {
            if (-not $script:mutexes[$mutexName]) { return }
            $mutex = $script:mutexes[$mutexName]

            if ($mutex.Status -eq "Open" -and $mutex.LockCount -le 0) { return }
            try {
                do {
                    $mutex.Object.ReleaseMutex()
                    $mutex.LockCount--
                }
                while ($Force)
            }
            catch [System.Management.Automation.MethodInvocationException] {
                $mutex.LockCount = 0
            }

            catch { $PSCmdlet.WriteError($_) }
            if ($mutex.LockCount -le 0) {
                $mutex.Status = 'Open'
            }
        }
    }
}