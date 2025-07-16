@echo off
echo Removing unnecessary GitHub workflows...
echo =======================================

cd /d "C:\Users\ygenk\Desktop\TMCloud"

echo Removing .github directory...
if exist .github (
    rmdir /s /q .github
    echo ✅ .github directory removed
) else (
    echo ⚠️ .github directory not found
)

echo Committing changes...
git add .
git commit -m "remove unnecessary CI/CD workflows - focus on Issues @cloud functionality"

echo Pushing changes...
git push origin main

if %ERRORLEVEL% EQU 0 (
    echo ✅ SUCCESS! Complex CI/CD workflows removed
    echo Now ready for simple Issues @cloud functionality
) else (
    echo ❌ Push failed
)

pause