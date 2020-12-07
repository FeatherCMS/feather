@echo off

REM Base Path (Shared with containers)
set BASE_PATH=C:%homepath%\docker-feather-data\embedded

set APP_NAME=feather-app-embedded

REM ## Start Feather App
docker stop %APP_NAME%
docker rm %APP_NAME%
docker run -d --restart=unless-stopped -v %BASE_PATH%:/var/feather  -p 8080:8080 --name %APP_NAME% feather

echo You can connect to: 
echo  http://127.0.0.1:8080
timeout 10