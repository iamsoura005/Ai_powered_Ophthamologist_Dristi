# Render Deployment PowerShell Script for Dristi AI
# This script ensures proper TensorFlow CPU installation for cloud deployment

Write-Host "🚀 Starting Render deployment for Dristi AI..." -ForegroundColor Green

# Set environment variables to force CPU-only TensorFlow
$env:TF_CPP_MIN_LOG_LEVEL = "2"
$env:DISABLE_TENSORFLOW_GPU = "1"
$env:PIP_NO_CACHE_DIR = "1"

# Navigate to backend directory
Set-Location "backend"

Write-Host "📦 Upgrading pip..." -ForegroundColor Yellow
pip install --upgrade pip

Write-Host "🧹 Cleaning any existing TensorFlow installations..." -ForegroundColor Yellow
try {
    pip uninstall -y tensorflow tensorflow-gpu tensorflow-cpu
} catch {
    Write-Host "No existing TensorFlow installations found" -ForegroundColor Gray
}

Write-Host "📋 Installing dependencies..." -ForegroundColor Yellow
pip install --no-cache-dir --force-reinstall -r ../requirements-render.txt

Write-Host "✅ Verifying TensorFlow installation..." -ForegroundColor Green
python -c "import tensorflow as tf; print(f'TensorFlow version: {tf.__version__}'); print(f'GPU available: {tf.config.list_physical_devices(\"GPU\")}')"

Write-Host "✅ Deployment preparation complete!" -ForegroundColor Green