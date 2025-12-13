#!/bin/bash

# Create venv if it doesn't exist
if [ ! -d "venv" ]; then
    echo "[+] Creating virtual environment..."
    python3 -m venv venv
fi

# Activate venv
echo "[+] Activating virtual environment..."
source venv/bin/activate

# Install dependency if missing
if ! python3 -c "import pdf2docx" &>/dev/null; then
    echo "[+] Installing pdf2docx..."
    pip install pdf2docx
fi

# Run converter
if [ $# -ne 2 ]; then
    echo "Usage: ./pdf-venv-docx.sh input.pdf output.docx"
    exit 1
fi

python3 pdf-to-docx.py "$1" "$2"
