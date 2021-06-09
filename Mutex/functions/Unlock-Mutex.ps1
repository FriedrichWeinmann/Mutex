function Unlock-Mutex {
    <#
    .SYNOPSIS
        Release the lock on a mutex you manage.

    .DESCRIPTION
        Release the lock on a mutex you manage.
        Will silently return if the mutex does not exist.

    .PARAMETER Name
        The name of the mutex to release the lock on.

    .EXAMPLE
        PS C:\> Unlock-Mutex -Name MyModule.LogFile

        Release the lock on the mutex 'MyModule.LogFile'

    .EXAMPLE
        PS C:\> Get-Mutex | Release-Mutex

        Release the lock on all mutexes managed.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Name
    )

    process {
        foreach ($mutexName in $Name) {
            if (-not $script:mutexes[$mutexName]) { return }
            $mutex = $script:mutexes[$mutexName]

            if ($mutex.Status -eq "Open" -and $mutex.LockCount -le 0) { return }
            if ($UnlockOnlyOnce) { $unLockCycleCount = 1 }else { $unLockCycleCount = $mutex.LockCount }
            try {
                # Repeat Releasing until MethodInvocationException is thrown
                while ($true) {
                    $mutex.Object.ReleaseMutex()
                }
            }
            catch [System.Management.Automation.MethodInvocationException] {
                $mutex.Status = 'Open'
            }
            catch {
                catch { $PSCmdlet.WriteError($_) }
            }
        }
    }
}