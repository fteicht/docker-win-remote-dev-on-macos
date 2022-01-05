# Switch to the DevUser account
$password = ConvertTo-SecureString 'Passw0rd' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ".\DevUser", $password
$session = New-PSSession -Credential $credential
Enter-PSSession $session

# Switch to the developper powershell
Invoke-Command -Session $session -ScriptBlock { `
    & "C:\Program Files (x86)\Microsoft Visual Studio\$using:env:BTYear\BuildTools\Common7\Tools\Launch-VsDevShell.ps1" `
}

# Move to the `Work` folder that is bound to our host working directory in the 'docker run' command
Invoke-Command -Session $session -ScriptBlock { `
    Set-Location "C:\Users\DevUser\Work" `
}

# Activate conda if Python is used in this container
If ($env:PVersion -ne "null") {
    Invoke-Command -Session $session -ScriptBlock { `
        & "C:\Miniconda3\shell\condabin\conda-hook.ps1" ; `
        conda activate "C:\Miniconda3" `
    }
}
