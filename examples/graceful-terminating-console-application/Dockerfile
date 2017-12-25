# escape=`
FROM powershell:6.0.0-rc as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://github.com/rgl/graceful-terminating-console-application-windows/releases/download/v0.4.0/graceful-terminating-console-application-windows.zip'; `
    $sha256 = 'f4ed0d2e05a9689d29f56ac084d9b49f53894250c24f13c9944903ed9f1342e0'; `
    Write-Host ('Downloading graceful-terminating-console-application-windows from {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile graceful-terminating-console-application-windows.zip; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash graceful-terminating-console-application-windows.zip -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive graceful-terminating-console-application-windows.zip .; `
    Write-Host 'Removing unneeded files...'; `
    Remove-Item graceful-terminating-console-application-windows.zip;

FROM microsoft/nanoserver:1709
# FROM microsoft/windowsservercore:1709
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/graceful-terminating-console-application-windows.exe /app/
RUN mkdir c:\host
VOLUME ["c:/host"]
WORKDIR /host
ENTRYPOINT ["C:/app/graceful-terminating-console-application-windows.exe", "600"]