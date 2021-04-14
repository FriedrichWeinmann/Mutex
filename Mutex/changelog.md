# Changelog

## 1.1.6 (2021-04-14)

+ New: Command Invoke-MutexCommand - execute a scriptblock under the protection of a mutex lock
+ New: Command Set-MutexDefault - manage default configuration for the mutex processing, such as default permissions on new mutexes.
+ Upd: Command New-Mutex - added parameters -Access and -Security to allow specifying permissions on the mutex object.
+ Upd: Mutex naming - by default, mutexes will be lowercased, to ensure case-insensitivity across PowerShell process boundaries.
+ Upd: Command New-Mutex - added parameter -CaseSpecific, allowing precise mutex cases needed for cross-language mutex coordination.
+ Upd: Command Remove-Mutex - will now also dispose the managed mutex type.

## 1.0.0 (2021-04-08)

+ Initial Release
