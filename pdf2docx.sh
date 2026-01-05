#!/bin/bash

# ==========================================
# PDF to DOCX Converter (Unified)
# Combines venv management and python logic
# ==========================================

# 1. Validate Arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 input.pdf output.docx"
    exit 1
fi

INPUT_PDF="$1"
OUTPUT_DOCX="$2"

# 2. Virtual Environment Setup
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
VENV_DIR="$DIR/venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "[+] Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# 3. Activate Environment
source "$VENV_DIR/bin/activate"

# 4. Install Dependencies if Missing
if ! python3 -c "import pdf2docx" &>/dev/null; then
    echo "[+] Installing pdf2docx..."
    pip install pdf2docx --quiet
fi

# 5. Run Embedded Python Logic
# We pass the shell arguments ($1 and $2) into the python script
python3 - "$INPUT_PDF" "$OUTPUT_DOCX" << 'EOF'
import sys
import os
from pdf2docx import Converter

def main():
    # sys.argv[0] is standard input (-), so args start at 1
    if len(sys.argv) < 3:
        print("Error: Arguments not passed to internal Python script.")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Verify input file exists
    if not os.path.exists(input_file):
        print(f"[!] Error: Input file '{input_file}' not found.")
        sys.exit(1)

    print(f"[+] Converting {input_file} -> {output_file} ...")

    try:
        cv = Converter(input_file)
        cv.convert(output_file)
        cv.close()
        print("[+] Conversion complete!")
    except Exception as e:
        print(f"[!] An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
EOF
