# 🚀 Quick Google Cloud Deployment

## One-Command Deployment

### **Prerequisites:**
1. Install Google Cloud SDK: https://cloud.google.com/sdk/docs/install
2. Authenticate: `gcloud auth login`
3. Create a project in Google Cloud Console

### **Deploy in 3 Steps:**

1. **Set your project ID:**
```bash
export PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID
```

2. **Enable billing and APIs:**
```bash
gcloud services enable cloudbuild.googleapis.com run.googleapis.com containerregistry.googleapis.com
```

3. **Deploy everything:**
```bash
chmod +x deploy-gcp.sh
./deploy-gcp.sh $PROJECT_ID
```

### **Alternative: Manual Cloud Build:**
```bash
gcloud builds submit --config cloudbuild.yaml .
```

### **Expected Output:**
- Backend URL: `https://medical-ai-backend-xxx-uc.a.run.app`
- Frontend URL: `https://medical-ai-frontend-xxx-uc.a.run.app`

### **Estimated Cost:**
- ~$50-80/month for moderate usage
- Scales to zero when not in use

### **Troubleshooting:**
- Check logs: `gcloud run services logs read medical-ai-backend --region us-central1`
- View builds: `gcloud builds list`
- Monitor: Google Cloud Console > Cloud Run

**That's it! Your Medical AI Platform is now live on Google Cloud! 🎉**
