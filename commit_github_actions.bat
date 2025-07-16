@echo off
echo Adding GitHub Actions files to TMCloud...
echo ==========================================

cd /d "C:\Users\ygenk\Desktop\TMCloud"

echo Current status:
git status --short

echo.
echo Adding GitHub Actions workflows...
git add .github/workflows/
git add scripts/create_test_database.py
git add .gitignore

echo.
echo Committing changes...
git commit -m "feat(ci): add GitHub Actions workflows for TMCloud

- Add CI/CD pipeline with automated testing
- Add deployment workflow for staging and production
- Add maintenance workflow for cleanup and security audits
- Create test database script for CI environment
- Update .gitignore to exclude test_output.db and large files

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo.
if %ERRORLEVEL% EQU 0 (
    echo ✅ Commit successful!
    echo.
    echo Files added:
    echo - .github/workflows/ci.yml (CI/CD pipeline)
    echo - .github/workflows/deploy.yml (Deployment automation)
    echo - .github/workflows/cleanup.yml (Maintenance tasks)
    echo - scripts/create_test_database.py (Test database)
    echo - Updated .gitignore
    echo.
    echo Ready to push to GitHub!
    echo Run 'push_to_github.bat' to push changes.
) else (
    echo ❌ Commit failed. Check git status and try again.
)

echo.
pause