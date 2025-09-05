# Render Deployment Guide for Dristi AI

## 🚀 How to Fix TensorFlow GPU Error on Render

The error you're encountering (`Could not find a version that satisfies the requirement tensorflow-gpu>=2.13.0`) is a common cloud deployment issue. Here's the complete solution:

### ✅ Problem Fixed

The issue was that some dependency or cached build was trying to install `tensorflow-gpu` instead of `tensorflow-cpu`. I've implemented several fixes:

### 🔧 Changes Made

1. **Updated Requirements Files** - All requirements files now use consistent versions of `tensorflow-cpu==2.20.0`
2. **Enhanced TensorFlow Configuration** - Added CPU-only enforcement in the backend code
3. **Created Render-Specific Configuration** - Added `render.yaml` with proper build commands
4. **Added Deployment Scripts** - Created scripts to ensure clean TensorFlow installation
5. **Updated nixpacks.toml** - Enhanced with TensorFlow GPU prevention

### 📦 Files Updated/Created

- ✅ `backend/requirements.txt` - Fixed TensorFlow version
- ✅ `api/requirements.txt` - Updated dependency versions
- ✅ `render.yaml` - New Render configuration
- ✅ `deploy_render.sh` - Linux deployment script
- ✅ `deploy_render.ps1` - Windows deployment script
- ✅ `requirements-production.txt` - Production-specific requirements
- ✅ `nixpacks.toml` - Enhanced with GPU prevention
- ✅ `backend/app.py` - Added CPU-only TensorFlow configuration

### 🚀 Deployment Steps for Render

#### Option 1: Use Render Dashboard (Recommended)

1. **Connect Your Repository**
   - Go to Render Dashboard
   - Click "New +" → "Web Service"
   - Connect your GitHub repository

2. **Configure Build Settings**
   ```
   Build Command: cd backend && pip install --upgrade pip && pip uninstall -y tensorflow tensorflow-gpu tensorflow-cpu || true && pip install --no-cache-dir --force-reinstall -r requirements.txt
   Start Command: cd backend && gunicorn --bind 0.0.0.0:$PORT app:app --timeout 300 --workers 1 --threads 2
   ```

3. **Set Environment Variables**
   ```
   PYTHON_VERSION=3.11.9
   PIP_NO_CACHE_DIR=1
   TF_CPP_MIN_LOG_LEVEL=2
   DISABLE_TENSORFLOW_GPU=1
   FLASK_ENV=production
   ```

#### Option 2: Use render.yaml (Infrastructure as Code)

1. **Deploy using the render.yaml file**
   - The `render.yaml` file is already configured
   - Render will automatically detect and use it
   - Just push your code and Render will deploy

### 🛠️ Environment Variables to Set in Render

Add these in your Render service environment variables:

```bash
PYTHON_VERSION=3.11.9
PIP_NO_CACHE_DIR=1
TF_CPP_MIN_LOG_LEVEL=2
DISABLE_TENSORFLOW_GPU=1
FLASK_ENV=production
SECRET_KEY=your-production-secret-key
JWT_SECRET_KEY=your-production-jwt-key
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
```

### 🔍 Troubleshooting

If you still encounter issues:

1. **Clear Render Cache**
   - Go to your service settings
   - Click "Clear cache and redeploy"

2. **Check Build Logs**
   - Look for any remaining tensorflow-gpu references
   - Ensure CPU-only TensorFlow is being installed

3. **Manual Deployment Script**
   - Run `./deploy_render.sh` (Linux) or `./deploy_render.ps1` (Windows) locally first
   - This will test the installation process

### ✅ Verification

After deployment, your app should log:
```
✅ TensorFlow 2.20.0 loaded (CPU-only mode)
```
✅ Eye disease model loaded successfully!
✅ Backend server ready!
```

### 🌐 Expected Results

- ✅ No more `tensorflow-gpu` errors
- ✅ Faster deployment (CPU-only is smaller)
- ✅ Better compatibility with Render's infrastructure
- ✅ Consistent behavior across all cloud platforms

### 📞 Support

If you still encounter issues:
1. Check the deployment logs in Render dashboard
2. Ensure all environment variables are set correctly
3. Try the "Clear cache and redeploy" option in Render

The deployment should now work perfectly on Render! 🎉