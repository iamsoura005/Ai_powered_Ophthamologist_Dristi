# 🚀 Google Cloud Platform Deployment Guide

## Medical AI Platform - Complete GCP Deployment

This guide will help you deploy the entire Medical AI Platform to Google Cloud Platform using Cloud Run, Cloud SQL, and other GCP services.

---

## 📋 **Prerequisites**

### 1. **Google Cloud Account**
- Active Google Cloud account with billing enabled
- Project with sufficient quotas for Cloud Run, Cloud SQL, and Storage

### 2. **Local Setup**
- Google Cloud SDK installed and configured
- Docker installed (for local testing)
- Git repository access

### 3. **Required Tools**
```bash
# Install Google Cloud SDK
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Verify installation
gcloud --version
```

---

## 🏗️ **Step-by-Step Deployment**

### **Step 1: Setup Google Cloud Project**

1. **Create a new project:**
```bash
# Set your project ID
export PROJECT_ID="medical-ai-platform-$(date +%s)"
gcloud projects create $PROJECT_ID
gcloud config set project $PROJECT_ID
```

2. **Enable billing:**
```bash
# Link billing account (replace BILLING_ACCOUNT_ID)
gcloud billing projects link $PROJECT_ID --billing-account=BILLING_ACCOUNT_ID
```

3. **Enable required APIs:**
```bash
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable secretmanager.googleapis.com
```

### **Step 2: Deploy Using Automated Script**

1. **Make deployment script executable:**
```bash
chmod +x deploy-gcp.sh
```

2. **Run deployment:**
```bash
./deploy-gcp.sh YOUR_PROJECT_ID
```

### **Step 3: Manual Deployment (Alternative)**

If you prefer manual deployment:

1. **Build and push Docker images:**
```bash
# Backend
docker build -t gcr.io/$PROJECT_ID/medical-ai-backend ./backend
docker push gcr.io/$PROJECT_ID/medical-ai-backend

# Frontend
docker build -t gcr.io/$PROJECT_ID/medical-ai-frontend ./frontend
docker push gcr.io/$PROJECT_ID/medical-ai-frontend
```

2. **Deploy to Cloud Run:**
```bash
# Deploy Backend
gcloud run deploy medical-ai-backend \
  --image gcr.io/$PROJECT_ID/medical-ai-backend \
  --region us-central1 \
  --platform managed \
  --allow-unauthenticated \
  --memory 2Gi \
  --cpu 2 \
  --timeout 300

# Deploy Frontend
gcloud run deploy medical-ai-frontend \
  --image gcr.io/$PROJECT_ID/medical-ai-frontend \
  --region us-central1 \
  --platform managed \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1
```

---

## 🗄️ **Database Setup (Optional)**

For production, consider using Cloud SQL:

1. **Create PostgreSQL instance:**
```bash
gcloud sql instances create medical-ai-db \
  --database-version=POSTGRES_13 \
  --tier=db-f1-micro \
  --region=us-central1
```

2. **Create database:**
```bash
gcloud sql databases create medical_ai --instance=medical-ai-db
```

3. **Update backend environment:**
```bash
gcloud run services update medical-ai-backend \
  --set-env-vars="DATABASE_URL=postgresql://user:pass@/medical_ai?host=/cloudsql/PROJECT_ID:us-central1:medical-ai-db"
```

---

## 🔐 **Environment Variables & Secrets**

### **Backend Environment Variables:**
```bash
gcloud run services update medical-ai-backend \
  --set-env-vars="FLASK_ENV=production,TF_CPP_MIN_LOG_LEVEL=2,CUDA_VISIBLE_DEVICES=-1"
```

### **Frontend Environment Variables:**
```bash
# Get backend URL
BACKEND_URL=$(gcloud run services describe medical-ai-backend --region=us-central1 --format="value(status.url)")

# Update frontend
gcloud run services update medical-ai-frontend \
  --set-env-vars="NEXT_PUBLIC_API_URL=$BACKEND_URL"
```

### **Secrets Management:**
```bash
# Create secrets for sensitive data
gcloud secrets create jwt-secret --data-file=jwt-secret.txt
gcloud secrets create openai-api-key --data-file=openai-key.txt

# Grant access to Cloud Run
gcloud secrets add-iam-policy-binding jwt-secret \
  --member="serviceAccount:PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

---

## 📊 **Monitoring & Logging**

### **View Logs:**
```bash
# Backend logs
gcloud logs tail "resource.type=cloud_run_revision AND resource.labels.service_name=medical-ai-backend"

# Frontend logs
gcloud logs tail "resource.type=cloud_run_revision AND resource.labels.service_name=medical-ai-frontend"
```

### **Monitoring:**
- Cloud Run automatically provides metrics
- Set up alerts in Cloud Monitoring
- Configure uptime checks

---

## 🌐 **Custom Domain (Optional)**

1. **Map custom domain:**
```bash
gcloud run domain-mappings create --service medical-ai-frontend --domain your-domain.com --region us-central1
```

2. **Configure DNS:**
- Add CNAME record pointing to `ghs.googlehosted.com`

---

## 💰 **Cost Optimization**

### **Cloud Run Settings:**
- **Memory:** Backend: 2Gi, Frontend: 1Gi
- **CPU:** Backend: 2, Frontend: 1
- **Concurrency:** 80 (default)
- **Min instances:** 0 (scales to zero)
- **Max instances:** 10

### **Expected Costs:**
- **Cloud Run:** ~$20-50/month (moderate usage)
- **Cloud SQL:** ~$25/month (db-f1-micro)
- **Storage:** ~$5/month
- **Total:** ~$50-80/month

---

## 🔧 **Troubleshooting**

### **Common Issues:**

1. **Build Failures:**
```bash
# Check build logs
gcloud builds log BUILD_ID
```

2. **Service Not Starting:**
```bash
# Check service logs
gcloud run services logs read medical-ai-backend --region us-central1
```

3. **Memory Issues:**
```bash
# Increase memory
gcloud run services update medical-ai-backend --memory 4Gi --region us-central1
```

### **Health Checks:**
```bash
# Test endpoints
curl https://YOUR_BACKEND_URL/health
curl https://YOUR_FRONTEND_URL/api/health
```

---

## 📈 **Scaling & Performance**

### **Auto-scaling Configuration:**
```bash
gcloud run services update medical-ai-backend \
  --min-instances=1 \
  --max-instances=20 \
  --concurrency=50
```

### **Performance Optimization:**
- Enable Cloud CDN for static assets
- Use Cloud Storage for large files
- Implement caching strategies

---

## 🔄 **CI/CD Pipeline**

The included `cloudbuild.yaml` provides:
- Automated builds on git push
- Multi-stage Docker builds
- Automatic deployment to Cloud Run
- Health checks and rollback

---

## ✅ **Verification Checklist**

After deployment, verify:
- [ ] Backend health endpoint responds
- [ ] Frontend loads correctly
- [ ] Image analysis works
- [ ] Color tests function
- [ ] Authentication works
- [ ] Database connections (if using Cloud SQL)
- [ ] Email notifications (if configured)

---

## 🆘 **Support**

For issues:
1. Check Cloud Run logs
2. Verify environment variables
3. Test locally with Docker
4. Review Cloud Build logs
5. Check service quotas

**Deployment completed successfully! 🎉**
