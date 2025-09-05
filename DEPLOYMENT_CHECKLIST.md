# 🚀 Dristi AI Deployment Checklist

## ✅ Pre-Deployment Verification

### 1. Local Testing
- [ ] Run `python verify_deployment.py` in backend directory
- [ ] Ensure all tests pass
- [ ] Check that TensorFlow CPU-only mode is active

### 2. Requirements Check
- [ ] All `requirements.txt` files use `tensorflow-cpu==2.13.0`
- [ ] No references to `tensorflow-gpu` anywhere
- [ ] Dependencies are consistent across all requirement files

### 3. Environment Configuration
- [ ] `TF_CPP_MIN_LOG_LEVEL=2` set
- [ ] `CUDA_VISIBLE_DEVICES=-1` set  
- [ ] `DISABLE_TENSORFLOW_GPU=1` set

## 🌐 Render Deployment Steps

### Step 1: Repository Setup
- [ ] Code pushed to GitHub/GitLab
- [ ] `render.yaml` file present in root directory
- [ ] Environment variables configured

### Step 2: Render Configuration
- [ ] Service connected to repository
- [ ] Build command set correctly
- [ ] Start command configured
- [ ] Environment variables added

### Step 3: Build Configuration
```bash
Build Command: cd backend && pip install --upgrade pip && pip uninstall -y tensorflow tensorflow-gpu tensorflow-cpu || true && pip install --no-cache-dir --force-reinstall -r requirements.txt

Start Command: cd backend && gunicorn --bind 0.0.0.0:$PORT app:app --timeout 300 --workers 1 --threads 2
```

### Step 4: Environment Variables
Set these in Render dashboard:
- [ ] `PYTHON_VERSION=3.11.9`
- [ ] `PIP_NO_CACHE_DIR=1`
- [ ] `TF_CPP_MIN_LOG_LEVEL=2`
- [ ] `DISABLE_TENSORFLOW_GPU=1`
- [ ] `FLASK_ENV=production`
- [ ] `SECRET_KEY=your-secret-key`
- [ ] `JWT_SECRET_KEY=your-jwt-key`

## 🔍 Post-Deployment Verification

### Check Deployment Logs
Look for these success messages:
- [ ] `✅ TensorFlow 2.13.0 loaded (CPU-only mode)`
- [ ] `✅ Eye disease model loaded successfully!`
- [ ] `✅ Backend server ready!`
- [ ] No `tensorflow-gpu` error messages

### Test API Endpoints
- [ ] `/health` endpoint returns 200
- [ ] Authentication endpoints work
- [ ] File upload works
- [ ] AI prediction works

### Performance Check
- [ ] App starts within 60 seconds
- [ ] Memory usage under 512MB
- [ ] No GPU-related warnings

## 🚨 Troubleshooting

If deployment fails:

1. **Clear Render Cache**
   - Go to service settings
   - Click "Clear cache and redeploy"

2. **Check Build Logs**
   - Look for tensorflow-gpu references
   - Verify CPU-only installation

3. **Re-run Deployment Script**
   ```bash
   # Linux/Mac
   ./deploy_render.sh
   
   # Windows
   ./deploy_render.ps1
   ```

4. **Manual Verification**
   ```bash
   python verify_deployment.py
   ```

## ✅ Success Criteria

Deployment is successful when:
- [ ] No TensorFlow GPU errors
- [ ] All API endpoints respond
- [ ] AI features work correctly
- [ ] Memory usage is stable
- [ ] No recurring errors in logs

## 📞 Support

If issues persist:
1. Check the comprehensive guide: `RENDER_DEPLOYMENT_GUIDE.md`
2. Review error logs in Render dashboard
3. Test locally first with verification script

---

**Status:** ⏳ Ready for deployment
**Last Updated:** $(date)
**Next Review:** After successful deployment