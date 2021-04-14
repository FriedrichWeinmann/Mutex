function Set-MutexDefault {
    <#
    .SYNOPSIS
        Set default settings for mutex processing.
    
    .DESCRIPTION
        Set default settings for mutex processing.
    
    .PARAMETER Access
        The default access set when creating new mutexes.
        - default: The system default permissions for mutexes. The creator and the system will have access.
        - anybody: Any authenticated person on the system can obtain mutex lock.
        - admins: Any process running with elevation can obtain mutex lock.
    
    .PARAMETER Security
        A custom mutex security object, governing access to newly created mutexes if not otherwise specified.
    
    .EXAMPLE
        PS C:\> Set-MutexDefault -Access admins

        Set new mutexes to be - by default - accessible by all elevated processes
    #>
    [CmdletBinding()]
    param (
        [ValidateSet('default', 'anybody', 'admins')]
        [string]
        $Access,

        [AllowNull()]
        [System.Security.AccessControl.MutexSecurity]
        $Security
    )

    process {
        if ($Access) {
            $script:mutexDefaultAccess = $Access
        }
        if ($PSBoundParameters.ContainsKey("Security")) {
            $script:mutexDefaultSecurity = $Security
        }
    }
}