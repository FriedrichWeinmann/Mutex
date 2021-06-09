function Test-Mutex {
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

    .EXAMPLE
        PS C:\> Test-Mutex -Name MyModule.LogFile

        Checks if the mutex 'MyModule.LogFile' has been created in another process.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Name
    )

    process {
        $result = $false
        if ($script:mutexes[$Name]) {
            $result = $true
        }
        else {
            $placeHolder = $null
            try {
                if ([System.Threading.Mutex]::TryOpenExisting($Name, [ref]$placeHolder) -eq $true) {
                    $result = $true
                }
            }
            catch {
                Write-Error $_
            }
        }
        $result
    }
}