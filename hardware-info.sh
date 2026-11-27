echo "===== SYSTEM ====="
sudo dmidecode -s system-product-name
sudo dmidecode -s system-version

echo "===== CPU ====="
lscpu | grep -E 'Model name|CPU\(s\)|Thread|Core'

echo "===== MEMORY ====="
free -h

echo "===== GPU ====="
lspci -nnk | grep -A3 -Ei 'VGA|3D|Display'

echo "===== INTEL GPU ====="
sudo apt install -y intel-gpu-tools
intel_gpu_top -L

echo "===== STORAGE ====="
lsblk -o NAME,SIZE,TYPE,MODEL

echo "===== OLLAMA ====="
ollama --version
ollama list
