import requests
from bs4 import BeautifulSoup
import csv
import subprocess
import os
from concurrent.futures import ThreadPoolExecutor

# Tor proxy settings
TOR_PROXY = "socks5h://127.0.0.1:9050"
session = requests.Session()
session.proxies = {'http': TOR_PROXY, 'https': TOR_PROXY}

# Function to check if Tor is running
def is_tor_running():
    try:
        result = subprocess.run(["systemctl", "is-active", "tor"], capture_output=True, text=True)
        return "active" in result.stdout
    except Exception:
        return False

# Function to restart Tor if needed
def restart_tor():
    print("Restarting Tor to maintain speed...")
    if is_tor_running():
        os.system("sudo kill -HUP $(pgrep tor)")
    else:
        print("Tor is not running. Starting Tor...")
        os.system("sudo systemctl start tor")

# Function to check if a .onion site is accessible
def is_onion_live(url):
    try:
        response = session.head(url, timeout=10, allow_redirects=True)
        return response.status_code == 200
    except requests.RequestException:
        return False

# Function to get the title of a .onion page
def get_title(url):
    try:
        response = session.get(url, timeout=5)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')

        # Handle missing title or empty title
        if soup.title and soup.title.string:
            return soup.title.string.strip()
        
        # Fallback: Use the first <h1> tag if title is missing
        h1_tag = soup.find("h1")
        if h1_tag and h1_tag.text.strip():
            return h1_tag.text.strip()

        return "No Title Found"
    
    except requests.RequestException as e:
        return f"Error: {str(e)}"

# Function to ensure URL has a scheme
def ensure_url_scheme(url):
    if not url.startswith("http://"):
        return "http://" + url  # Add http:// if no scheme exists
    return url

# Function to process a single .onion site
def process_site(site):
    site = ensure_url_scheme(site)
    
    try:
        if is_onion_live(site):
            title = get_title(site)
        else:
            title = "Offline or Unreachable"
    except UnicodeError as e:
        print(f"Skipping {site} due to URL formatting error: {e}")
        title = "Error: URL too long or malformed"
    
    # ANSI escape code for red text
    RED = "\033[31m"
    RESET = "\033[0m"

    print(f"{site} -> {RED}{title}{RESET}")
    return [site, title]

# Input and output files
input_file = "results.onion.csv"
output_file = "onion_page_titles.csv"

# Read .onion URLs from file
with open(input_file, "r", encoding="utf-8") as f:
    onion_sites = [line.strip() for line in f if line.strip()]

# Using ThreadPoolExecutor to process requests concurrently
with open(output_file, "w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["Onion Site", "Title"])

    # Limit the number of threads (adjust as needed, 10 threads as example)
    with ThreadPoolExecutor(max_workers=24) as executor:
        results = executor.map(process_site, onion_sites)
        
        # Write results to file
        for result in results:
            if isinstance(result, (list, tuple)) and len(result) == 2:  # Ensure valid format
                site, title = result
                if isinstance(site, str) and site.endswith(".onion"):  # Only save .onion sites
                    writer.writerow([site, title])  # Correct indentation
                else:
                    print(f"Skipping invalid entry: {result}")
            else:
                print(f"Malformed result entry: {result}")

        # Restart Tor every 15 requests (safe method)
        if len(onion_sites) % 15 == 0:
            restart_tor()
print()
print(f"Results saved to {output_file}")
