#!/bin/bash
# Environment setup script for Linux/macOS
# Creates Python virtual environment and installs dependencies

set -e

echo "Setting up development environment..."

# Check Python availability
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 is not installed"
    exit 1
fi

# Create virtual environment
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
else
    echo "Virtual environment already exists"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install requirements
echo "Installing dependencies..."
pip install -r requirements.txt

echo ""
echo "Setup complete!"
echo ""
echo "To activate the environment in the future, run:"
echo "  source .venv/bin/activate"
echo ""
echo "Common commands:"
echo "  esphome config m5stack-atom-s3r.yaml     # Validate configuration"
echo "  esphome compile m5stack-atom-s3r.yaml    # Compile firmware"
echo "  esphome upload m5stack-atom-s3r.yaml     # Upload to device"
echo "  esphome logs m5stack-atom-s3r.yaml       # View logs"
