"C:\Program Files (x86)\Microsoft Visual Studio\%BTYear%\BuildTools\Common7\Tools\VsDevCmd.bat" ^
&& start powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& Start-Sleep 5 ; ./spinner.exe service sshd -t C:\ProgramData\ssh\logs\sshd.log" ^
&& powershell.exe -NoLogo -ExecutionPolicy Bypass
