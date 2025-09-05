@echo off
REM Deployment fix script for TensorFlow compatibility issues
REM This script updates dependencies and pushes changes to GitHub

echo 🔧 Fixing TensorFlow compatibility issues and updating GitHub...

REM Check if we're in the right directory
if not exist "README.md" (
    echo ❌ Error: Please run this script from the project root directory
    exit /b 1
)

REM Check git status
echo 📊 Checking git status...
git status

REM Add all changes
echo 📝 Adding all changes to git...
git add .

REM Commit changes
echo 💾 Committing changes...
git commit -m "Fix TensorFlow compatibility issues

- Update tensorflow-cpu from 2.15.0 to 2.13.0 for Render compatibility
- Update numpy, pillow, scipy to compatible versions
- Add Render-specific requirements file with tested versions
- Update Vercel runtime to Python 3.11
- Fix deployment configurations for better stability

This resolves the recurring deployment error:
'Could not find a version that satisfies the requirement tensorflow-cpu==2.15.0'"

REM Push to GitHub
echo 🚀 Pushing to GitHub...
git push origin main

echo ✅ Successfully updated GitHub with TensorFlow compatibility fixes!
echo.
echo 🎯 Key changes made:
echo    - TensorFlow-CPU: 2.15.0 → 2.13.0
echo    - NumPy: 1.24.3 → 1.26.4
echo    - Pillow: 10.0.1 → 10.4.0
echo    - SciPy: 1.11.3 → 1.13.1
echo    - Added requirements-render.txt for Render deployment
echo    - Updated Vercel to Python 3.11
echo.
echo 🔄 Your deployment should now work without the TensorFlow error!

pause