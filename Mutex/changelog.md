# Changelog

## 1.1.11 (2021-06-17)

+ New: Command Test-Mutex - test whether a Mutex exists. (#8 ; @Callidus2000)
+ Upd: Unlock-Mutex - added `-Force` parameter to enable unlocking all Mutex locks in the current process. (#8 ; @Callidus2000)

## 1.1.9 (2021-06-03)

+ Fix: After acquiring the same lock multiple times in the same process, it will never fully unlock again, guaranteeing a deadlock.

## 1.1.8 (2021-05-19)

+ Fix: Invoke-MutexCommand - executes code twice
+ Fix: Remove-Mutex - error when trying to call `Dispose()`

## 1.1.6 (2021-04-14)

+ New: Command Invoke-MutexCommand - execute a scriptblock under the protection of a mutex lock
+ New: Command Set-MutexDefault - manage default configuration for the mutex processing, such as default permissions on new mutexes.
+ Upd: Command New-Mutex - added parameters -Access and -Security to allow specifying permissions on the mutex object.
+ Upd: Mutex naming - by default, mutexes will be lowercased, to ensure case-insensitivity across PowerShell process boundaries.
+ Upd: Command New-Mutex - added parameter -CaseSpecific, allowing precise mutex cases needed for cross-language mutex coordination.
+ Upd: Command Remove-Mutex - will now also dispose the managed mutex type.

## 1.0.0 (2021-04-08)

+ Initial Release
