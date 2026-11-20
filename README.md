# winfstest
Windows file system testing. Inspired by the FreeBSD fstest, but written from scratch to work on Windows.

Based from work of Bill Zissimopoulos, https://bitbucket.org/billziss/secfs.test

Prerequisites:
* Visual Studio 2019 or later (the project builds with the installed toolset)
* Windows 10 SDK
* Python 3.8 or later

To run:
* Build winfstest.exe with Visual Studio (winfstest.sln); it is written to TestSuite\winfstest.exe
* cd TestSuite
* run-winfstest.bat
* run-winfstest.bat finds Python 3 using, in order: the Python launcher (py -3), python on PATH, the Python registry keys (HKCU/HKLM), then C:\Python3*
* On NTFS you should see: total ... ok 568/568. On recent Windows 10/11 releases, 3 tests in t\base\08_CreateFile_Delete.t fail on NTFS (565/568) because DeleteFile removes the name immediately (POSIX delete semantics) instead of leaving it delete-pending

To test another location, give the test directory (relative to TestSuite) and a path: run-winfstest.bat . X:\tmp\

Failing tests are reported as "not ok" lines but do not change the exit code; a non-zero exit code means a test script itself failed to run.
