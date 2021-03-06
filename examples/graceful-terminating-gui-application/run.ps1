@(
    'mcr.microsoft.com/windows/nanoserver:1809'
    'mcr.microsoft.com/windows/servercore:1809'
    'mcr.microsoft.com/windows:1809'
) | ForEach-Object {
    Set-Content `
        -Encoding utf8 `
        -Path Dockerfile.tmp `
        -Value (
            (Get-Content -Raw Dockerfile) `
                -replace 'FROM \$BASEIMAGE',"FROM $_"
        )
    $title = "graceful-terminating-gui-application $_"

    $dataPath = 'C:\graceful-terminating-gui-application'
    mkdir -Force $dataPath | Out-Null
    Remove-Item -ErrorAction SilentlyContinue -Force "$dataPath\graceful-terminating-gui-application-windows.log"

    Write-Output 'building the container...'
    time {docker build -t graceful-terminating-gui-application --file Dockerfile.tmp .}

    Write-Output 'getting the container history...'
    docker history graceful-terminating-gui-application

    Write-Output 'running the container in background...'
    try {docker rm --force graceful-terminating-gui-application} catch {}
    # TODO there seems to be an Emulategui property that we can pass to docker... check it out! is -t enough?
    time {docker run -d --volume "${dataPath}:C:\host" --name graceful-terminating-gui-application graceful-terminating-gui-application}

    Write-Output 'sleeping a bit before stopping the container...'
    Start-Sleep -Seconds 15
    Write-Output 'stopping the container...'
    # XXX the shutdown procedure inside a container is broken.
    #     a service does not seem to receive any stop notification.
    #     see https://github.com/moby/moby/issues/25982
    # XXX docker/windows seems to ignore the --time argument...
    docker stop --time 600 graceful-terminating-gui-application

    Write-Output "getting the $title container logs..."
    docker logs graceful-terminating-gui-application | ForEach-Object {"    $_"}

    Write-Output "getting the $title log file..."
    Get-Content "$dataPath\graceful-terminating-gui-application-windows.log"
}

Remove-Item -Force Dockerfile.tmp
