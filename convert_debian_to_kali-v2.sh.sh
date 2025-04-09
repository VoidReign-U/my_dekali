#!/bin/bash

# Choose Language
echo -e "${GREEN}Choose Language / اختر اللغة:"
echo "1) English"
echo "2) العربية"
read -rp "> " lang

# Validate language input
if [[ "$lang" != "1" && "$lang" != "2" ]]; then
    echo "Invalid choice. Please select either 1 or 2."
    exit 1
fi

if [[ "$lang" == "2" ]]; then
    echo -e "${CYAN}هذا السكربت سيحول ديبيان إلى بيئة كالي نظيفة بدون زوائد عبر إضافة المستودعات الرسمية.${NC}"
    echo "سيتم استخدام aptitude وتثبيت الأدوات لاحقًا يدويًا حسب رغبتك."
    read -rp "هل تريد المتابعة؟ (نعم/لا): " confirm
    if [[ "$confirm" != "نعم" ]]; then
        echo "تم الإلغاء."
        exit 1
    fi
else
    echo -e "${CYAN}This script will convert Debian into a Kali-like environment by adding official Kali repos.${NC}"
    echo "It uses aptitude. Tools can be installed manually later as needed."
    read -rp "Do you want to proceed? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        echo "Cancelled."
        exit 1
    fi
fi

# Backup sources.list before making changes
echo -e "${GREEN}[*] Backing up your current sources.list...${NC}"
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# Add Kali Repo
echo -e "${GREEN}[*] Adding Kali repository...${NC}"
echo "deb http://kali.download/kali kali-rolling main contrib non-free" | sudo tee /etc/apt/sources.list.d/kali.list

# Add GPG key
echo -e "${GREEN}[*] Adding Kali GPG key...${NC}"
wget -qO - https://archive.kali.org/archive-key.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kali.gpg

# Update + install aptitude
echo -e "${GREEN}[*] Updating package list and installing aptitude...${NC}"
sudo apt update && sudo apt install -y aptitude

# Use netselect-apt to speed up repository mirrors
echo -e "${GREEN}[*] # Use netselect-apt to speed up repository mirrors...${NC}"
sudo netselect-apt
clear

# Select Desktop Environment
echo -e "${GREEN}Choose a desktop environment to install / اختر بيئة سطح المكتب:"
echo "1) XFCE"
echo "2) GNOME"
echo "3) LXQt"
echo "4) KDE Plasma"
echo "5) MATE"
echo "6) Server (No Desktop)"
echo "7) Install DWM from GitHub"
read -rp "> " desktop_choice

case $desktop_choice in
  1)
    echo -e "${CYAN}Installing XFCE...${NC}"
    sudo apt install -y xfce4
    ;;
  2)
    echo -e "${CYAN}Installing GNOME...${NC}"
    sudo apt install -y gnome-shell
    ;;
  3)
    echo -e "${CYAN}Installing LXQt...${NC}"
    sudo apt install -y lxqt
    ;;
  4)
    echo -e "${CYAN}Installing KDE Plasma...${NC}"
    sudo apt install -y kde-plasma-desktop
    ;;
  5)
    echo -e "${CYAN}Installing MATE...${NC}"
    sudo apt install -y mate-desktop-environment
    ;;
  6)
    echo -e "${CYAN}Installing Server (No Desktop)...${NC}"
    sudo apt install -y tasksel
    sudo tasksel install minimal
    ;;
  7)
    echo -e "${CYAN}Installing DWM from GitHub...${NC}"
    read -rp "Enter the GitHub repository URL for your custom DWM: " github_url
    git clone "$github_url" ~/dwm
    cd ~/dwm || exit
    make
    sudo make install
    echo -e "${CYAN}DWM has been installed successfully from GitHub.${NC}"
    
    # Check if DWM was installed successfully
    if command -v dwm &>/dev/null; then
        echo -e "${CYAN}dwm was installed successfully.${NC}"
    else
        echo -e "${RED}Failed to install dwm.${NC}"
    fi
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

# Ask if user wants to install tools now
read -rp "Do you want to install tools now? (yes/no): " tools_choice
if [[ "$tools_choice" == "yes" || "$tools_choice" == "نعم" ]]; then
    echo -e "${CYAN}Installing tools (nmap gobuster hydra john metasploit-framework Temux)...${NC}"
    
    # Add your tools here. For example:
    # sudo apt install -y nmap gobuster burpsuite hydra

    # Example list of tools:
    sudo apt install -y nmap gobuster hydra john metasploit-framework Temux

    # You can add more tools as needed, just modify this section.
fi

# Done
echo -e "${GREEN}[✔] Done. Your Debian now has Kali sources and the selected desktop environment installed.${NC}"
echo -e "${CYAN}-- Script by: VidReign  --${NC}"
