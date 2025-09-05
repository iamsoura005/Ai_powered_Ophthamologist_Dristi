# Render Deployment Script for Dristi AI
# This script ensures proper TensorFlow CPU installation for cloud deployment

#!/bin/bash
set -e

echo "🚀 Starting Render deployment for Dristi AI..."

# Set environment variables to force CPU-only TensorFlow
export TF_CPP_MIN_LOG_LEVEL=2
export DISABLE_TENSORFLOW_GPU=1
export PIP_NO_CACHE_DIR=1

# Navigate to backend directory
cd backend

echo "📦 Upgrading pip..."
pip install --upgrade pip

echo "🧹 Cleaning any existing TensorFlow installations..."
pip uninstall -y tensorflow tensorflow-gpu tensorflow-cpu || true

echo "📋 Installing dependencies..."
pip install --no-cache-dir --force-reinstall -r requirements.txt

echo "✅ Verifying TensorFlow CPU installation..."
python -c "import tensorflow as tf; print(f'TensorFlow version: {tf.__version__}'); print(f'GPU available: {tf.config.list_physical_devices(\"GPU\")}')"

echo "✅ Deployment preparation complete!"