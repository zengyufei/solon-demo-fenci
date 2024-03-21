chcp 65001
@echo off

echo 清理

cd %~dp0
cd /D solon-demo-fenci

call mvn -U -T 1C clean -Dmaven.test.skip=true

cd %~dp0
cd ./bin

pause
