#!/bin/bash

# ==================================================================
# KALI LINUX SMART LOCK & AUTO-UNLOCK
# ==================================================================
# 1. Phone Away -> Lock Screen.
# 2. Phone Return -> Unlock Screen (Auto-login).
# 3. Run it! ./smart-lock.sh
# ==================================================================

# --- CONFIGURATION ---
PHONE_MAC="B0:D5:FB:BB:BF:32"   # YOUR Phone MAC (Change this)
TARGET_USER="kali"              # YOUR User
PING_INTERVAL=3                 # Seconds between checks
MAX_MISSED_PINGS=2              # Failures before locking

# --- UNLOCK METHOD ---
# "standard" = Tries polite loginctl unlock (safest, might only wake screen)
# "force"    = Kills the screensaver process (Aggressive, effectively logs in)
UNLOCK_MODE="force" 

# --- INTERNAL STATE ---
MISSED_COUNT=0
SYSTEM_ARMED=false 

# Check for root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./smart-lock.sh)"
  exit
fi

# Function to get the user's GUI session ID
get_session_id() {
    loginctl list-sessions --no-legend | grep "$TARGET_USER" | grep "seat0" | awk '{print $1}' | head -n 1
}

# Function to check if screen is currently locked
is_session_locked() {
    SESSION_ID=$(get_session_id)
    if [ -z "$SESSION_ID" ]; then return 1; fi
    
    # Returns "LockedHint=yes" if locked
    if loginctl show-session "$SESSION_ID" -p LockedHint | grep -q "yes"; then
        return 0 # True, it is locked
    else
        return 1 # False, it is unlocked
    fi
}

lock_target_session() {
    SESSION_ID=$(get_session_id)
    if [ -n "$SESSION_ID" ]; then
        echo "--> Locking Session ID: $SESSION_ID"
        loginctl lock-session "$SESSION_ID"
    fi
}

unlock_target_session() {
    SESSION_ID=$(get_session_id)
    
    if [ "$UNLOCK_MODE" == "standard" ]; then
        echo "--> Unlocking via loginctl (Standard)..."
        loginctl unlock-session "$SESSION_ID"
        
    elif [ "$UNLOCK_MODE" == "force" ]; then
        echo "--> Unlocking via Process Kill (Force)..."
        # This kills the specific lock screen process for the user
        pkill -u "$TARGET_USER" xfce4-screensaver
        pkill -u "$TARGET_USER" light-locker
        
        # Ensure the session is marked active
        loginctl unlock-session "$SESSION_ID"
    fi
}

echo "=== Smart Monitor Started for $PHONE_MAC ==="
echo "Mode: Auto-Lock + Auto-Unlock ($UNLOCK_MODE)"

while true; do
    # Active ping (1 packet, 2s timeout)
    l2ping -c 1 -t 2 "$PHONE_MAC" > /dev/null 2>&1
    PING_STATUS=$?

    if [ $PING_STATUS -eq 0 ]; then
        # =========================================
        # STATUS: PHONE IS CONNECTED
        # =========================================
        MISSED_COUNT=0
        
        # If the system is locked, and phone is here, UNLOCK IT.
        if is_session_locked; then
            echo "[+] Phone returned. Screen is locked. Unlocking..."
            unlock_target_session
            SYSTEM_ARMED=true
        elif [ "$SYSTEM_ARMED" = false ]; then
            echo "[+] Phone detected. System ARMED."
            SYSTEM_ARMED=true
        fi

    else
        # =========================================
        # STATUS: PHONE IS DISCONNECTED
        # =========================================
        if [ "$SYSTEM_ARMED" = true ]; then
            MISSED_COUNT=$((MISSED_COUNT + 1))
            
            if [ $MISSED_COUNT -ge $MAX_MISSED_PINGS ]; then
                echo "[!] Phone gone. Locking screen."
                lock_target_session
                
                # We disarm so we don't spam the lock command
                SYSTEM_ARMED=false
                echo "[-] System DISARMED (Waiting for return...)"
            fi
        fi
    fi

    sleep $PING_INTERVAL
done
