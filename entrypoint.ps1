# Create the DevUser account
$password = ConvertTo-SecureString 'Passw0rd' -AsPlainText -Force
New-LocalUser "DevUser" -Password $password
Add-LocalGroupMember -Group "Administrators" -Member "DevUser"

# Switch to the DevUser account
$credential = New-Object System.Management.Automation.PSCredential ".\DevUser", $password
New-PSSession -Credential $credential | Enter-PSSession

# Bind the DevUser's Work folder to the C:\Temp\Dev folder bound in the 'docker run' command.
# If we would have used the DevUser's Work folder directly as bound volume in the 'docker run'
# command, it would have created first a different DevUser account, forcing the DevUser account
# created in this script to be placed in another domain by Windows.
New-Item -ItemType SymbolicLink -Path "C:\Users\DevUser\Work" -Target "C:\Temp\Dev"
Set-Location "C:\Users\DevUser\Work"

# Switch to the developer powershell
& "C:\Program Files (x86)\Microsoft Visual Studio\$env:BTYear\BuildTools\Common7\Tools\Launch-VsDevShell.ps1"
