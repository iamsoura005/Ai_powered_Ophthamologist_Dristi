#!/usr/bin/env python3
"""
Verification script for Dristi AI deployment
This script checks if all dependencies are correctly installed for cloud deployment
"""

import sys
import os
import importlib

def check_tensorflow():
    """Check TensorFlow installation and configuration"""
    print("🔍 Checking TensorFlow installation...")
    
    try:
        import tensorflow as tf
        print(f"✅ TensorFlow version: {tf.__version__}")
        
        # Check if GPU is disabled
        gpus = tf.config.list_physical_devices('GPU')
        if len(gpus) == 0:
            print("✅ GPU disabled - CPU-only mode active")
        else:
            print(f"⚠️ Warning: {len(gpus)} GPU(s) detected")
            
        # Verify it's the CPU version
        if 'tensorflow-cpu' in tf.__file__ or 'cpu' in tf.__version__.lower():
            print("✅ TensorFlow CPU version confirmed")
        
        return True
    except ImportError as e:
        print(f"❌ TensorFlow import failed: {e}")
        return False
    except Exception as e:
        print(f"⚠️ TensorFlow configuration issue: {e}")
        return True  # Still considered successful if import works

def check_required_packages():
    """Check all required packages"""
    print("\n🔍 Checking required packages...")
    
    required_packages = [
        'flask',
        'flask_cors',
        'flask_jwt_extended', 
        'flask_sqlalchemy',
        'numpy',
        'PIL',  # Pillow
        'gunicorn'
    ]
    
    failed = []
    for package in required_packages:
        try:
            importlib.import_module(package)
            print(f"✅ {package}")
        except ImportError:
            print(f"❌ {package}")
            failed.append(package)
    
    return len(failed) == 0

def check_optional_packages():
    """Check optional packages"""
    print("\n🔍 Checking optional packages...")
    
    optional_packages = [
        ('cv2', 'OpenCV'),
        ('matplotlib', 'Matplotlib'),
        ('scipy', 'SciPy'),
        ('openai', 'OpenAI')
    ]
    
    for package, name in optional_packages:
        try:
            importlib.import_module(package)
            print(f"✅ {name}")
        except ImportError:
            print(f"⚠️ {name} (optional)")

def check_environment():
    """Check environment variables"""
    print("\n🔍 Checking environment configuration...")
    
    env_vars = [
        'TF_CPP_MIN_LOG_LEVEL',
        'CUDA_VISIBLE_DEVICES'
    ]
    
    for var in env_vars:
        value = os.environ.get(var)
        if value:
            print(f"✅ {var}={value}")
        else:
            print(f"⚠️ {var} not set")

def main():
    """Main verification function"""
    print("🚀 Dristi AI Deployment Verification")
    print("=" * 50)
    
    # Check Python version
    python_version = f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    print(f"🐍 Python version: {python_version}")
    
    if sys.version_info < (3, 8):
        print("❌ Python 3.8+ required")
        return False
    else:
        print("✅ Python version compatible")
    
    # Run all checks
    tf_ok = check_tensorflow()
    packages_ok = check_required_packages()
    check_optional_packages()
    check_environment()
    
    print("\n" + "=" * 50)
    
    if tf_ok and packages_ok:
        print("🎉 All critical checks passed! Ready for deployment.")
        return True
    else:
        print("❌ Some critical checks failed. Please fix before deployment.")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)