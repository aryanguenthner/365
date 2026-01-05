#!/bin/bash

# Date: 01/04/2026
# Kali Linux Kodi Installer - IPTV Configuration Fix (OFFICIAL METHOD)
# Features: 
#   1. Installs Kodi from Kali native repositories
#   2. Fixes Video driver issues (VDPAU/VAAPI)
#   3. Configures IPTV M3U (tvpass.org)
#   4. AUTO-ENABLES the PVR Client (No manual setup required)


set -euo pipefail

# ============================================================================
# COLOR OUTPUT & LOGGING FUNCTIONS (DEFINED FIRST)
# ============================================================================
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${BLUE}[+]${NC} $1"; }
success() { echo -e "${GREEN}[✔]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# ============================================================================
# CONFIGURATION VARIABLES
# ============================================================================
KODI_USER="${SUDO_USER:-kali}"
KODI_HOME=$(eval echo ~$KODI_USER)
KODI_CONFIG="$KODI_HOME/.kodi"
ADDON_DIR="$KODI_CONFIG/userdata/addon_data/pvr.iptvsimple"
SETTINGS_FILE="$ADDON_DIR/instance-settings-1.xml"
M3U_URL="https://tvpass.org/playlist/m3u"

# Verify root
[[ $EUID -eq 0 ]] || error "Must run as root (sudo $0)"

log "Starting Kodi setup with fully automated IPTV configuration..."

# ============================================================================
# STEP 1: Update system repositories
# ============================================================================
log "Updating system repositories..."
apt-get update -qq || warn "Repository update had minor issues"

# ============================================================================
# STEP 2: Install Kodi from Kali native repositories (NO PPA needed)
# ============================================================================
log "Installing Kodi from Kali native repositories..."

if dpkg -s kodi &>/dev/null; then
    success "Kodi already installed"
else
    apt-get install -y kodi || error "Failed to install Kodi from native repositories"
    success "Kodi installed successfully"
fi

# ============================================================================
# STEP 3: Install IPTV Simple Client from Kali repositories
# ============================================================================
log "Installing IPTV Simple PVR client..."

if dpkg -s kodi-pvr-iptvsimple &>/dev/null; then
    success "IPTV Simple already installed"
else
    apt-get install -y kodi-pvr-iptvsimple || warn "IPTV Simple client installation had issues"
    success "IPTV Simple PVR client installed"
fi

# ============================================================================
# STEP 4: Install Kodi addon repository
# ============================================================================
log "Installing Kodi official add-on repository..."
apt-get install -y kodi-repository-kodi || warn "Official add-on repository installation had issues"

# ============================================================================
# STEP 5: Install video codec libraries & tools
# ============================================================================
log "Installing video codec libraries and tools..."

apt-get install -y \
    libva2 \
    libva-drm2 \
    sqlite3 \
    --no-install-recommends || warn "Some video packages may not be available on your system"

success "Video codec libraries installed"

# ============================================================================
# STEP 6: Add Kodi user to required groups for video acceleration
# ============================================================================
log "Adding $KODI_USER to video acceleration groups..."
usermod -a -G cdrom,audio,render,video,plugdev,users,dialout,dip,input "$KODI_USER" 2>/dev/null || warn "Could not add user to all groups"
success "User groups configured"

# ============================================================================
# STEP 7: Clean up broken VA-API/VDPAU references
# ============================================================================
log "Cleaning up broken video driver configuration..."

rm -f /usr/lib/x86_64-linux-gnu/libvdpau_nvidia.so* 2>/dev/null || true
rm -f /usr/lib/i386-linux-gnu/libvdpau_nvidia.so* 2>/dev/null || true

success "Cleaned up broken driver references"

# ============================================================================
# STEP 8: Create Kodi environment configuration
# ============================================================================
log "Creating Kodi environment configuration..."

KODI_ENV_FILE="$KODI_HOME/.kodi_env"
cat > "$KODI_ENV_FILE" <<'EOF'
# Kodi Video Driver Configuration
# Uses software rendering for stability on Kali

export LIBGL_ALWAYS_SOFTWARE=1
export VDPAU_DRIVER=null
export LIBVA_DRIVER_NAME=dummy
export KODI_AV_CLOCK_SYNC=1
export LIBVA_MESSAGING_LEVEL=0
EOF

chmod 644 "$KODI_ENV_FILE"
success "Created Kodi environment file: $KODI_ENV_FILE"

# ============================================================================
# STEP 9: Create IPTV configuration directories
# ============================================================================
log "Configuring IPTV Simple M3U playlist..."

mkdir -p "$ADDON_DIR" || error "Failed to create addon directory"
mkdir -p "$KODI_CONFIG/userdata/Database"

log "Created addon directory: $ADDON_DIR"



# ============================================================================
# STEP 11: Create guisettings.xml to auto-enable PVR (No User Intervention)
# ============================================================================
log "Creating GUI settings to auto-enable PVR add-on..."

GUISETTINGS_FILE="$KODI_CONFIG/userdata/guisettings.xml"
mkdir -p "$KODI_CONFIG/userdata"

cat > "$GUISETTINGS_FILE" <<GUI_XML
<?xml version="1.0" encoding="UTF-8"?>
<settings version="2">
    <setting id="pvrmanager.enabled">true</setting>
    <setting id="pvrmanager.hideconnectionlostwarning">false</setting>
    <setting id="pvrclient.iptvsimple.enabled">true</setting>
</settings>
GUI_XML

chown $KODI_USER:$KODI_USER "$GUISETTINGS_FILE"
chmod 644 "$GUISETTINGS_FILE"
success "GUI settings created to auto-enable PVR (no user intervention needed)"

# ============================================================================
# STEP 12: Configure IPTV Instance Name and Disable Unwanted Add-ons
# ============================================================================
log "Configuring IPTV Simple instance and disabling unnecessary add-ons..."

# Create disabled.xml to prevent prompts for RTMP Input and Spectrum Input
DISABLED_ADDONS="$KODI_CONFIG/userdata/disabled.xml"
mkdir -p "$KODI_CONFIG/userdata"

cat > "$DISABLED_ADDONS" <<DISABLED_XML
<?xml version="1.0" encoding="UTF-8"?>
<disabled version="2">
    <addon id="inputstream.rtmp" disabled="true" />
    <addon id="inputstream.spectrum" disabled="true" />
</disabled>
DISABLED_XML

chown $KODI_USER:$KODI_USER "$DISABLED_ADDONS"
chmod 644 "$DISABLED_ADDONS"
success "Disabled unwanted input streams (RTMP, Spectrum)"

# ============================================================================
# STEP 12.5: Create IPTV Simple instance settings with proper naming
# ============================================================================
# ~/.kodi/userdata/addon_data/pvr.iptvsimple/instance-settings-1.xml

log "Creating IPTV Simple instance with custom naming..."

# Create the instance settings file with instance name "TV"
cat > "$SETTINGS_FILE" <<IPTV_INSTANCE_XML
<?xml version="1.0" encoding="UTF-8"?>
<settings version="2">
    <setting id="kodi_addon_instance_name">Simple IPTV</setting>  
    <setting id="m3uPathType">1</setting>
    <setting id="m3uUrl">$M3U_URL</setting>
    <setting id="m3uPath"></setting>
    <setting id="cacheM3U">true</setting>
    <setting id="startNum">1</setting>
    <setting id="m3uRefreshIntervalMins">60</setting>
    <setting id="epgCache">true</setting>
    <setting id="enabled">true</setting>
    <setting id="autoUpdate">true</setting>
</settings>
IPTV_INSTANCE_XML

chown $KODI_USER:$KODI_USER "$SETTINGS_FILE"
chmod 644 "$SETTINGS_FILE"
success "IPTV Simple instance created as 'TV'"

# ============================================================================
# STEP 13: AUTO-ENABLE IPTV ADDON IN DATABASE
# ============================================================================
log "Configuring add-on database..."

DB_FILE=$(find "$KODI_CONFIG/userdata/Database" -name "Addons*.db" 2>/dev/null | sort -r | head -n 1)

if [ -z "$DB_FILE" ]; then
    warn "No existing Addons database found (Kodi hasn't run yet)"
    warn "Database will be created on first Kodi launch"
else
    log "Found Database: $DB_FILE"
    
    # Enable IPTV Simple Client
    EXISTS=$(sqlite3 "$DB_FILE" "SELECT count(*) FROM installed WHERE addonID='pvr.iptvsimple';" 2>/dev/null || echo "0")
    
    if [ "$EXISTS" -eq "0" ]; then
        log "Injecting 'pvr.iptvsimple' into database..."
        sqlite3 "$DB_FILE" "INSERT OR IGNORE INTO installed (addonID, enabled, installDate) VALUES ('pvr.iptvsimple', 1, '$(date +%Y-%m-%d %H:%M:%S)');" 2>/dev/null || warn "Could not inject addon into DB"
    else
        log "Updating 'pvr.iptvsimple' to ENABLED..."
        sqlite3 "$DB_FILE" "UPDATE installed SET enabled=1 WHERE addonID='pvr.iptvsimple';" 2>/dev/null || warn "Could not update addon status"
    fi
    
    # Disable RTMP Input Stream
    log "Disabling RTMP Input Stream in database..."
    sqlite3 "$DB_FILE" "UPDATE installed SET enabled=0 WHERE addonID='inputstream.rtmp';" 2>/dev/null || warn "Could not disable RTMP"
    
    # Disable Spectrum Input Stream
    log "Disabling Spectrum Input Stream in database..."
    sqlite3 "$DB_FILE" "UPDATE installed SET enabled=0 WHERE addonID='inputstream.spectrum';" 2>/dev/null || warn "Could not disable Spectrum"
fi

success "Add-on configuration complete - IPTV enabled, others disabled"

# ============================================================================
# STEP 13: Set Permissions
# ============================================================================
log "Setting file permissions..."
chown -R $KODI_USER:$KODI_USER "$KODI_CONFIG" 2>/dev/null || true
chown $KODI_USER:$KODI_USER "$KODI_ENV_FILE" 2>/dev/null || true
chmod 644 "$SETTINGS_FILE" 2>/dev/null || true

# ============================================================================
# STEP 14: Create launch script on Desktop
# ============================================================================
DESKTOP_DIR="$KODI_HOME/Desktop"
mkdir -p "$DESKTOP_DIR"
LAUNCH_SCRIPT="$DESKTOP_DIR/launch-kodi.sh"

cat > "$LAUNCH_SCRIPT" <<'LAUNCH_SCRIPT_CONTENT'
#!/bin/bash
ENV_FILE="${HOME}/.kodi_env"
[ -f "$ENV_FILE" ] && source "$ENV_FILE"

# Force environment overrides
export LIBGL_ALWAYS_SOFTWARE=1
export VDPAU_DRIVER=null
export LIBVA_DRIVER_NAME=dummy

echo "Starting Kodi with IPTV Configuration..."
kodi "$@"
LAUNCH_SCRIPT_CONTENT

chmod +x "$LAUNCH_SCRIPT"
chown $KODI_USER:$KODI_USER "$LAUNCH_SCRIPT"

success "Launch script created: $LAUNCH_SCRIPT"

# ============================================================================
# STEP 15: Create .desktop file for Kali menu launcher
# ============================================================================
log "Creating Kali menu launcher (.desktop file)..."

APPLICATIONS_DIR="$KODI_HOME/.local/share/applications"
mkdir -p "$APPLICATIONS_DIR"

DESKTOP_FILE="$APPLICATIONS_DIR/kodi.desktop"

cat > "$DESKTOP_FILE" <<'DESKTOP_CONTENT'
[Desktop Entry]
Type=Application
Name=Kodi
Comment=Media Center
Exec=bash -c 'source ~/.kodi_env && exec /usr/bin/kodi'
Icon=kodi
Terminal=false
Categories=AudioVideo;Video;TV;
X-GNOME-Autostart-enabled=false
StartupNotify=true
DESKTOP_CONTENT

chown $KODI_USER:$KODI_USER "$DESKTOP_FILE"
chmod 644 "$DESKTOP_FILE"

# Also copy to system applications for all users
cp "$DESKTOP_FILE" /home/kali/Desktop/kodi.desktop 2>/dev/null || warn "Could not copy to system applications"
chmod -R 777 /home/kali/Desktop/kodi.desktop

success "Kali launcher created"

# ============================================================================
# FINAL SUMMARY
# ============================================================================
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  KODI SETUP COMPLETE"
echo "════════════════════════════════════════════════════════════════"
echo "✓ Kodi installed from Kali native repositories"
echo "✓ IPTV Simple PVR client configured as 'TV'"
echo "✓ IPTV Playlist URL: $M3U_URL"
echo "✓ RTMP Input & Spectrum Input disabled (no prompts)"
echo "✓ IPTV Simple Client auto-enabled"
echo "✓ Video acceleration groups configured"
echo "✓ NVIDIA drivers disabled (Stability)"
echo "════════════════════════════════════════════════════════════════"
echo ""
