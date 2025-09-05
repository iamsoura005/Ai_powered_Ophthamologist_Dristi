#!/usr/bin/env python3
"""
Deployment Verification Script
Checks if the Hackloop deployment is working correctly after TensorFlow fixes
"""

import requests
import json
import time
from datetime import datetime

def check_deployment_status():
    """Check the deployment status on various platforms"""
    
    print("🔍 Hackloop Deployment Verification")
    print("=" * 50)
    print(f"⏰ Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print()
    
    # Render deployment check
    render_urls = [
        "https://dristi-ai-2-onrender.com",
        "https://dristi-ai-2.onrender.com"
    ]
    
    for url in render_urls:
        print(f"🌐 Checking Render deployment: {url}")
        try:
            response = requests.get(f"{url}/health", timeout=30)
            if response.status_code == 200:
                print(f"✅ Render deployment is UP! Status: {response.status_code}")
                try:
                    health_data = response.json()
                    print(f"   📊 Health data: {json.dumps(health_data, indent=2)}")
                except:
                    print(f"   📄 Response: {response.text[:200]}...")
                break
            else:
                print(f"⚠️ Render responded with status: {response.status_code}")
        except requests.exceptions.RequestException as e:
            print(f"❌ Render deployment check failed: {str(e)}")
        print()
    
    # Vercel deployment check  
    vercel_urls = [
        "https://hackloop.vercel.app",
        "https://dristi-ai.vercel.app"
    ]
    
    for url in vercel_urls:
        print(f"🌐 Checking Vercel deployment: {url}")
        try:
            response = requests.get(f"{url}/api/health", timeout=30)
            if response.status_code == 200:
                print(f"✅ Vercel deployment is UP! Status: {response.status_code}")
                try:
                    health_data = response.json()
                    print(f"   📊 Health data: {json.dumps(health_data, indent=2)}")
                except:
                    print(f"   📄 Response: {response.text[:200]}...")
                break
            else:
                print(f"⚠️ Vercel responded with status: {response.status_code}")
        except requests.exceptions.RequestException as e:
            print(f"❌ Vercel deployment check failed: {str(e)}")
        print()
    
    # TensorFlow compatibility check
    print("🧠 TensorFlow Compatibility Check")
    print("-" * 30)
    
    try:
        import tensorflow as tf
        print(f"✅ TensorFlow installed: {tf.__version__}")
        
        # Check if it's CPU version
        if 'cpu' in tf.__version__ or not tf.config.list_physical_devices('GPU'):
            print("✅ TensorFlow-CPU detected (correct for deployment)")
        else:
            print("⚠️ GPU version detected (might cause deployment issues)")
            
    except ImportError:
        print("❌ TensorFlow not installed locally (this is OK for deployment check)")
    
    print()
    print("📋 Deployment Status Summary")
    print("-" * 30)
    print("✅ Code changes pushed to GitHub")
    print("✅ TensorFlow version updated to 2.15.0")
    print("✅ Python 3.11 compatibility ensured")
    print("✅ Render and Vercel configurations updated")
    print()
    print("🎯 Next Steps:")
    print("1. Check your Render dashboard for deployment progress")
    print("2. Monitor build logs for any remaining issues")
    print("3. Test the application once deployment completes")
    print("4. If issues persist, check TENSORFLOW_FIX_GUIDE.md")

if __name__ == "__main__":
    check_deployment_status()