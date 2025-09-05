#!/bin/bash
# Deployment script for HackLoop Medical AI
# This script automates the deployment process to Vercel

echo "=========================================="
echo "    HackLoop Medical AI Deployment"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    print_warning "Vercel CLI not found. Installing..."
    npm install -g vercel
    if [ $? -eq 0 ]; then
        print_status "Vercel CLI installed successfully"
    else
        print_error "Failed to install Vercel CLI"
        exit 1
    fi
fi

# Check if user is logged in to Vercel
print_info "Checking Vercel authentication..."
if ! vercel whoami &> /dev/null; then
    print_warning "Not logged in to Vercel. Please login..."
    vercel login
fi

# Build frontend
print_info "Building frontend..."
cd frontend
npm install --legacy-peer-deps
if [ $? -ne 0 ]; then
    print_error "Frontend dependencies installation failed"
    exit 1
fi

npm run build
if [ $? -ne 0 ]; then
    print_error "Frontend build failed"
    exit 1
fi
print_status "Frontend build completed"

cd ..

# Deploy to Vercel
print_info "Deploying to Vercel..."
vercel --prod

if [ $? -eq 0 ]; then
    print_status "Deployment completed successfully!"
    echo ""
    echo "Your HackLoop Medical AI application is now live!"
    echo ""
    print_info "Next steps:"
    echo "1. Set up environment variables in Vercel dashboard"
    echo "2. Configure your email settings"
    echo "3. Test all functionality"
    echo ""
    print_info "Environment variables to set:"
    echo "- SECRET_KEY"
    echo "- JWT_SECRET_KEY"
    echo "- MAIL_USERNAME"
    echo "- MAIL_PASSWORD"
    echo "- OPENROUTER_API_KEY (optional)"
    echo ""
else
    print_error "Deployment failed"
    exit 1
fi