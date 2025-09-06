#!/bin/bash

# Medical AI Platform - Google Cloud Deployment Script
# This script deploys the entire application to Google Cloud Platform

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ID=${1:-"medical-ai-platform"}
REGION="us-central1"
BACKEND_SERVICE="medical-ai-backend"
FRONTEND_SERVICE="medical-ai-frontend"

echo -e "${BLUE}🚀 Starting deployment of Medical AI Platform to Google Cloud${NC}"
echo -e "${BLUE}Project ID: ${PROJECT_ID}${NC}"
echo -e "${BLUE}Region: ${REGION}${NC}"

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ Google Cloud SDK is not installed. Please install it first.${NC}"
    echo -e "${YELLOW}Visit: https://cloud.google.com/sdk/docs/install${NC}"
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo -e "${YELLOW}⚠️ Not authenticated with Google Cloud. Please run:${NC}"
    echo -e "${YELLOW}gcloud auth login${NC}"
    exit 1
fi

# Set the project
echo -e "${BLUE}📋 Setting project to ${PROJECT_ID}${NC}"
gcloud config set project ${PROJECT_ID}

# Enable required APIs
echo -e "${BLUE}🔧 Enabling required Google Cloud APIs...${NC}"
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable secretmanager.googleapis.com

# Build and deploy using Cloud Build
echo -e "${BLUE}🏗️ Building and deploying with Cloud Build...${NC}"
gcloud builds submit --config cloudbuild.yaml .

# Get service URLs
echo -e "${GREEN}✅ Deployment completed!${NC}"
echo -e "${GREEN}Getting service URLs...${NC}"

BACKEND_URL=$(gcloud run services describe ${BACKEND_SERVICE} --region=${REGION} --format="value(status.url)")
FRONTEND_URL=$(gcloud run services describe ${FRONTEND_SERVICE} --region=${REGION} --format="value(status.url)")

echo -e "${GREEN}🌐 Service URLs:${NC}"
echo -e "${GREEN}Backend:  ${BACKEND_URL}${NC}"
echo -e "${GREEN}Frontend: ${FRONTEND_URL}${NC}"

# Update frontend environment variable with backend URL
echo -e "${BLUE}🔧 Updating frontend with backend URL...${NC}"
gcloud run services update ${FRONTEND_SERVICE} \
    --region=${REGION} \
    --set-env-vars="NEXT_PUBLIC_API_URL=${BACKEND_URL}"

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${GREEN}🎉 Your Medical AI Platform is now live at: ${FRONTEND_URL}${NC}"

# Health checks
echo -e "${BLUE}🏥 Performing health checks...${NC}"
echo -e "${BLUE}Checking backend health...${NC}"
if curl -f "${BACKEND_URL}/health" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend is healthy${NC}"
else
    echo -e "${YELLOW}⚠️ Backend health check failed${NC}"
fi

echo -e "${BLUE}Checking frontend health...${NC}"
if curl -f "${FRONTEND_URL}/api/health" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend is healthy${NC}"
else
    echo -e "${YELLOW}⚠️ Frontend health check failed${NC}"
fi

echo -e "${GREEN}🎊 Deployment Summary:${NC}"
echo -e "${GREEN}• Backend Service: ${BACKEND_SERVICE}${NC}"
echo -e "${GREEN}• Frontend Service: ${FRONTEND_SERVICE}${NC}"
echo -e "${GREEN}• Region: ${REGION}${NC}"
echo -e "${GREEN}• Project: ${PROJECT_ID}${NC}"
echo -e "${GREEN}• Frontend URL: ${FRONTEND_URL}${NC}"
echo -e "${GREEN}• Backend URL: ${BACKEND_URL}${NC}"
