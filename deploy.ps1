# Deployment script for HackLoop Medical AI
# This script automates the deployment process to Vercel

Write-Host ""
Write-Host "=========================================="
Write-Host "    HackLoop Medical AI Deployment"
Write-Host "=========================================="
Write-Host ""

function Write-Success {
    param($Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Warning {
    param($Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error {
    param($Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Info {
    param($Message)
    Write-Host "ℹ $Message" -ForegroundColor Blue
}

# Check if Vercel CLI is installed
try {
    $vercelVersion = vercel --version 2>$null
    Write-Success "Vercel CLI found: $vercelVersion"
} catch {
    Write-Warning "Vercel CLI not found. Installing..."
    npm install -g vercel
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Vercel CLI installed successfully"
    } else {
        Write-Error "Failed to install Vercel CLI"
        exit 1
    }
}

# Check if user is logged in to Vercel
Write-Info "Checking Vercel authentication..."
$whoami = vercel whoami 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Not logged in to Vercel. Please login..."
    vercel login
}

# Build frontend
Write-Info "Building frontend..."
Set-Location "frontend"

Write-Info "Installing frontend dependencies..."
npm install --legacy-peer-deps
if ($LASTEXITCODE -ne 0) {
    Write-Error "Frontend dependencies installation failed"
    exit 1
}

Write-Info "Building frontend..."
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Error "Frontend build failed"
    exit 1
}
Write-Success "Frontend build completed"

Set-Location ".."

# Deploy to Vercel
Write-Info "Deploying to Vercel..."
vercel --prod

if ($LASTEXITCODE -eq 0) {
    Write-Success "Deployment completed successfully!"
    Write-Host ""
    Write-Host "Your HackLoop Medical AI application is now live!" -ForegroundColor Green
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host "1. Set up environment variables in Vercel dashboard"
    Write-Host "2. Configure your email settings"
    Write-Host "3. Test all functionality"
    Write-Host ""
    Write-Info "Environment variables to set:"
    Write-Host "- SECRET_KEY"
    Write-Host "- JWT_SECRET_KEY"
    Write-Host "- MAIL_USERNAME"
    Write-Host "- MAIL_PASSWORD"
    Write-Host "- OPENROUTER_API_KEY (optional)"
    Write-Host ""
    Write-Host "🎉 Deployment completed!" -ForegroundColor Green
} else {
    Write-Error "Deployment failed"
    exit 1
}