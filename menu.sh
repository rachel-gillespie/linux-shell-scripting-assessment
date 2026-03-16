#!/bin/bash
# Author:      Rachel Gillespie
# Student ID:  20118715
# Course:      Higher Diploma in Computer Science
# Description: Main menu script for the Hospital Appointment Management System.
#              Presents the user with options to Add, View, Search, Remove or Quit.

# ── Colours ────────────────────────────────────────────────────────────────────
# -e flag on echo enables colour codes (ANSI colour codes researched to improve UI)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Colour

# ── Data file ──────────────────────────────────────────────────────────────────
APPOINTMENTS_FILE="appointments.txt"

# ── Check if appointments file exists, create it if not ───────────────────────
[ -f ./appointments.txt ] && : || touch ./appointments.txt

# ── Welcome banner ─────────────────────────────────────────────────────────────
clear
echo -e "${CYAN}"
echo "-----------------------------------------------"
echo "        HOSPITAL APPOINTMENT SYSTEM            "
echo "-----------------------------------------------"
echo -e "         WELCOME, $USER!                    ${NC}"
echo ""

# ── PS3 sets the prompt text for the select menu ──────────────────────────────
PS3='Please enter your choice: '

# ── Menu options array ─────────────────────────────────────────────────────────
options=("View All Appointments" "Add Appointment" "Search Appointments" "Remove Appointment" "Quit")

# ── Outer loop keeps the menu running after each action ───────────────────────
while true; do

    echo -e "${CYAN}"
    echo "-----------------------------------------------"
    echo "                  MAIN MENU                    "
    echo "-----------------------------------------------"
    echo -e "${YELLOW}  At any prompt: (M) Main Menu  |  (Q) Quit   ${NC}"
    echo ""

    # 'select' generates a numbered menu from the options array
    select opt in "${options[@]}"; do

        case $opt in

            "View All Appointments")
                echo ""
                echo -e "${CYAN}-----------------------------------------------${NC}"
                echo "             ALL APPOINTMENTS                  "
                echo -e "${CYAN}-----------------------------------------------${NC}"
                # Check if file is empty before displaying
                if [ ! -s "$APPOINTMENTS_FILE" ]; then
                    echo -e "${RED}No appointments found.${NC}"
                else
                    # cat prints the file contents to the screen
                    cat "$APPOINTMENTS_FILE"
                fi
                echo -e "${CYAN}-----------------------------------------------${NC}"
                break
                ;;

            "Add Appointment")
                # Call the add.sh script to add a new appointment
                ./add.sh
                break
                ;;

            "Search Appointments")
                # Call the search.sh script to search for an appointment
                ./search.sh
                break
                ;;

            "Remove Appointment")
                # Call the remove.sh script to remove an appointment
                ./remove.sh
                break
                ;;

            "Quit")
                # Exit the program with a goodbye message
                echo -e "${RED}"
                echo "-----------------------------------------------"
                echo "   YOU CHOSE TO EXIT, GOODBYE $USER!           "
                echo "-----------------------------------------------"
                echo -e "${NC}"
                exit 0
                ;;

            *)
                if [ "$REPLY" = "Q" ] || [ "$REPLY" = "q" ]; then
                    exit 0
                fi
                # Add this — M at the main menu just redraws it
                if [ "$REPLY" = "M" ] || [ "$REPLY" = "m" ]; then
                    break
                fi
                echo -e "${RED}Invalid option. Please try again.${NC}"
                ;;

        esac
    done
done