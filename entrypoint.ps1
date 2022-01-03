# Start the SSH service
Start-Job -ScriptBlock {& ./spinner.exe service sshd -t C:\ProgramData\ssh\logs\sshd.log}

# Create the dockeruser account
$password = ConvertTo-SecureString 'Passw0rd' -AsPlainText -Force
New-LocalUser "dockeruser" -Password $password
Add-LocalGroupMember -Group "Administrators" -Member "dockeruser"
$dockeruserdomain = gwmi win32_useraccount | where {$_.caption -match 'dockeruser'} | select domain | select -ExpandProperty "domain"

# Switch to the dockeruser account
$credential = New-Object System.Management.Automation.PSCredential "$dockeruserdomain\dockeruser", $password
New-PSSession -Credential $credential | Enter-PSSession

# Bind the dockeruser's Documents\DockerWork folder to the C:\Users\dockeruser folder bound in the 'docker run' command.
# This trick allows us to circumvent the fact that we don't know the dockeruser's domain name when binding the
# C:\Users\dockeruser folder in the 'docker run' command.
New-Item -ItemType SymbolicLink -Path "C:\Users\dockeruser.$dockeruserdomain\Documents\DockerWork" -Target "C:\Users\dockeruser"
Set-Location "C:\Users\dockeruser.$dockeruserdomain\Documents\DockerWork"

# Switch to the developer powershell
& "C:\Program Files (x86)\Microsoft Visual Studio\$env:BTYear\BuildTools\Common7\Tools\Launch-VsDevShell.ps1"
