# escape=`
FROM powershell:6.0.0-rc as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://github.com/rgl/graceful-terminating-windows-service/releases/download/v0.2.0/graceful-terminating-windows-service.zip'; `
    $sha256 = '6678b8fb331991433aa7c70c21d1162229644426fdacbdbe89977259652e93ef'; `
    Write-Host ('Downloading graceful-terminating-windows-service from {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile graceful-terminating-windows-service.zip; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash graceful-terminating-windows-service.zip -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive graceful-terminating-windows-service.zip .; `
    Write-Host 'Removing unneeded files...'; `
    Remove-Item graceful-terminating-windows-service.zip;

FROM powershell:6.0.0-rc
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# FROM microsoft/windowsservercore:1709
# SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/graceful-terminating-windows-service.exe /app/
WORKDIR /app
COPY install.ps1 ./
COPY entrypoint.ps1 ./
USER ContainerAdministrator
RUN ./install.ps1
RUN mkdir c:/host | Out-Null
VOLUME ["c:/host"]
ENTRYPOINT .\entrypoint.ps1