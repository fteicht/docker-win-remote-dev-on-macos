# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

RUN `
    # Download the Build Tools bootstrapper.
    curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe `
    `
    # Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
    && (start /w vs_buildtools.exe --quiet --wait --norestart --nocache modify `
        --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" `
        --add Microsoft.VisualStudio.Workload.AzureBuildTools `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
        --remove Microsoft.VisualStudio.Component.Windows81SDK `
        || IF "%ERRORLEVEL%"=="3010" EXIT 0) `
    `
    # Cleanup
    && del /q vs_buildtools.exe

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV SPINNER_VERSION 1.0.8
COPY install-openssh.ps1 install-openssh.ps1
RUN ./install-openssh.ps1

# Create a test account
RUN net user /add User03 Passw0rd

# Install Spinner to watch a Windows service
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; \
    Invoke-WebRequest $('https://github.com/ticketmaster/spinner/releases/download/v{0}/spinner_windows_amd64-v{0}.zip' -f $env:SPINNER_VERSION) -OutFile spinner.zip -UseBasicParsing ; \
    Expand-Archive spinner.zip ; \
    Remove-Item spinner.zip ; \
    Move-Item spinner\spinner_v$env:SPINNER_VERSION.exe spinner.exe ; \
    Remove-Item spinner
CMD Start-Sleep 5 ; ./spinner.exe service sshd -t C:\ProgramData\ssh\logs\sshd.log
