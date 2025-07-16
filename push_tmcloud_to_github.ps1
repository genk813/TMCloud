# TMCloud GitHub Actions Push Script
Write-Host "Adding GitHub Actions files to TMCloud..." -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Change to TMCloud directory
Set-Location "C:\Users\ygenk\Desktop\TMCloud"

# Check current status
Write-Host "Current git status:" -ForegroundColor Yellow
git status --short

# Add new files
Write-Host "`nAdding GitHub Actions workflows..." -ForegroundColor Yellow
git add .github/workflows/
git add scripts/create_test_database.py
git add .gitignore

# Commit changes
Write-Host "`nCommitting changes..." -ForegroundColor Yellow
git commit -m @"
feat(ci): add GitHub Actions workflows for TMCloud

- Add CI/CD pipeline with automated testing
- Add deployment workflow for staging and production  
- Add maintenance workflow for cleanup and security audits
- Create test database script for CI environment
- Update .gitignore to exclude test_output.db and large files

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
"@

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Commit successful!" -ForegroundColor Green
    
    Write-Host "`nFiles added:" -ForegroundColor Cyan
    Write-Host "- .github/workflows/ci.yml (CI/CD pipeline)" -ForegroundColor White
    Write-Host "- .github/workflows/deploy.yml (Deployment automation)" -ForegroundColor White
    Write-Host "- .github/workflows/cleanup.yml (Maintenance tasks)" -ForegroundColor White
    Write-Host "- scripts/create_test_database.py (Test database)" -ForegroundColor White
    Write-Host "- Updated .gitignore" -ForegroundColor White
    
    Write-Host "`nPushing to GitHub..." -ForegroundColor Yellow
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n🎉 SUCCESS! TMCloud with GitHub Actions is now on GitHub!" -ForegroundColor Green
        Write-Host "Repository: https://github.com/genk813/TMCloud" -ForegroundColor Cyan
        Write-Host "`nCheck the Actions tab on GitHub to see the workflows in action!" -ForegroundColor Yellow
    } else {
        Write-Host "`n❌ Push failed. Please check:" -ForegroundColor Red
        Write-Host "1. Network connection" -ForegroundColor White
        Write-Host "2. GitHub authentication" -ForegroundColor White
        Write-Host "3. Repository permissions" -ForegroundColor White
    }
} else {
    Write-Host "`n❌ Commit failed. Check git status and try again." -ForegroundColor Red
}

Write-Host "`nPress any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")