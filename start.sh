#!/bin/sh
# Railway startup script with better error handling

echo "Starting DeepFake Detection Backend..."
echo "PORT: $PORT"
echo "Python version: $(python --version)"
echo "Working directory: $(pwd)"
echo "Files in current directory:"
ls -la

# Create required directories
mkdir -p uploads logs data/temp model

# Check if model file exists
if [ -f "model/xception_model.h5" ]; then
    echo "✓ Model file found"
else
    echo "⚠ Model file not found - app will run but predictions may fail"
fi

# Start Gunicorn
echo "Starting Gunicorn on port $PORT..."
exec gunicorn app:app \
    --bind 0.0.0.0:$PORT \
    --timeout 300 \
    --workers 1 \
    --threads 2 \
    --log-level info \
    --access-logfile - \
    --error-logfile - \
    --capture-output \
    --enable-stdio-inheritance
