@echo off

REM Stop Tomcat
net stop Tomcat10

REM Remove existing deployment
if exist "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\medical_store_war_exploded" (
    rmdir /s /q "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\medical_store_war_exploded"
)

REM Copy new deployment
xcopy /E /I /Y "src\main\webapp" "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\medical_store_war_exploded"

REM Start Tomcat
net start Tomcat10

pause
