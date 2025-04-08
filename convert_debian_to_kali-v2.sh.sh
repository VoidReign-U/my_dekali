#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
CYAN="\e[36m"
NC="\e[0m"

dragon_art() {
cat << "EOF"
      \                    / \  //\
       \    |\___/|      /   \//  \\
            /O  O  \__  /    //  | \ \    
           /     /  \/_/    //   |  \  \  
           @_^_@'/   \/_   //    |   \   \ 
           //_^_/     \\/_//     |    \    \  
        ( //) |        \///      |     \     \  
      ( / /) _|_ /   )  //       |      \     _\ 
    ( // /) '/,_ _ _/  (~        |       \  /   
  (( / / )) ,-{        _    _-_ |        ~   
 (( // / ))  '/\      /        /       
 (( /// ))      `.   <_,' |--|-\  
  (( / ))     ____)    (__/_____) 
EOF
}

# Libyan Flag (symbolic)
draw_flag() {
    echo -e "${RED}🇱🇾  LIBYA  🇱🇾${NC}"
}

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

clear
draw_flag
dragon_art

if [[ "$lang" == "2" ]]; then
    echo -e "${CYAN}هذا السكربت سيحول ديبيان إلى بيئة تشبه كالي عبر إضافة المستودعات الرسمية.${NC}"
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

# Done
echo -e "${GREEN}[✔] Done. Your Debian now has Kali sources. Be cautious using mixed packages.${NC}"
echo -e "${CYAN}-- Script by: VidReign 🇱🇾 --${NC}"
