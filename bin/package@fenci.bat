chcp 65001
@echo off

echo 打包

cd %~dp0
cd /D solon-demo-fenci

call mvn -U -T 1C clean package -Dmaven.test.skip=true

cd %~dp0
cd ./bin

pause
