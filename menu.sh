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
# ASCII art generated to improve UI appearance
# clear is used before the banner to ensure a clean screen on startup
clear
echo -e "${CYAN}"
echo "---------------------------------------------------------------"
echo " _   _  ___  ____  ____ ___ _____  _    _                          
| | | |/ _ \/ ___||  _ \_ _|_   _|/ \  | |                         
| |_| | | | \___ \| |_) | |  | | / _ \ | |                         
|  _  | |_| |___) |  __/| |  | |/ ___ \| |___                      
|_| |_|\___/|____/|_| _|___|_|_/_/_ _\_\_____|__ _____ _   _ _____ 
   / \  |  _ \|  _ \ / _ \_ _| \ | |_   _|  \/  | ____| \ | |_   _|
  / _ \ | |_) | |_) | | | | ||  \| | | | | |\/| |  _| |  \| | | |  
 / ___ \|  __/|  __/| |_| | || |\  | | | | |  | | |___| |\  | | |  
/_/___\_\_|___|_|____\___/___|_| \_| |_| |_|  |_|_____|_| \_| |_|  
/ ___\ \ / / ___|_   _| ____|  \/  |                               
 \___ \\ V /\___ \ | | |  _| | |\/| |                               
 ___) || |  ___) || | | |___| |  | |                               
|____/ |_| |____/ |_| |_____|_|  |_|                               "
echo "---------------------------------------------------------------"
echo -e "         WELCOME, $USER!                    ${NC}"
echo ""

# ── PS3 sets the prompt text for the select menu ──────────────────────────────
PS3='Please enter your choice: '

# ── Menu options array ─────────────────────────────────────────────────────────
options=("View All Appointments" "View Specific Appointment" "Add Appointment" "Search Appointments" "Remove Appointment" "Quit")

# ── Outer loop keeps the menu running after each action ───────────────────────
while true
do

    echo -e "${CYAN}"
    echo "-----------------------------------------------"
    echo "                  MAIN MENU                    "
    echo "-----------------------------------------------"
    echo -e "${YELLOW}  At any prompt: (M) Main Menu  |  (Q) Quit   ${NC}"
    echo ""

    # 'select' generates a numbered menu from the options array
    select opt in "${options[@]}"
    do

        case $opt in

            "View All Appointments")
                echo ""
                echo -e "${CYAN}-----------------------------------------------${NC}"
                echo "             ALL APPOINTMENTS                  "
                echo -e "${CYAN}-----------------------------------------------${NC}"
                if [ ! -s "$APPOINTMENTS_FILE" ]
                then
                    echo -e "${RED}No appointments found.${NC}"
                else
                    # printf formats each column to a fixed width for neat alignment
                    # %-Xs means left-aligned, X characters wide
                    printf "%-6s %-18s %-12s %-30s %-30s %-12s %-12s %-16s %-15s %-12s %-5s %-12s\n" \
                        "ID" "Name" "Phone" "Email" "Address" "County" "DOB" "Doctor" "Department" "Date" "Time" "Status"
                    echo -e "${CYAN}$(printf '%0.s-' {1..188})${NC}"
                    # awk -F'|' splits on pipe delimiter and prints each field in aligned columns
                    awk -F'|' '{printf "%-6s %-18s %-12s %-30s %-30s %-12s %-12s %-16s %-15s %-12s %-5s %-12s\n", \
                        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' "$APPOINTMENTS_FILE"
                    echo -e "${CYAN}$(printf '%0.s-' {1..188})${NC}"
                fi
                break
                ;;
            
            "View Specific Appointment")
            # Ask user for a Patient ID to view a specific record
            echo ""
            echo -e "${YELLOW}Enter Patient ID to view (e.g. P001):${NC}"
            read viewid

            if [ "$viewid" = "Q" ] || [ "$viewid" = "q" ]
            then
                echo -e "${RED}Exiting system. Goodbye $USER!${NC}"
                exit 0
            fi

            if [ "$viewid" = "M" ] || [ "$viewid" = "m" ]
            then
                break
            fi

            if [ -z "$viewid" ]
            then
                echo -e "${RED}Patient ID cannot be blank!${NC}"
            else
                # Search only field 1 (ID) using exact match == to find the specific record
                result=$(awk -F'|' '$1 == "'"$viewid"'"' "$APPOINTMENTS_FILE")

                if [ -z "$result" ]
                then
                    echo -e "${RED}No appointment found with ID: $viewid${NC}"
                else
                    echo ""
                    echo -e "${CYAN}-----------------------------------------------${NC}"
                    echo "  Appointment Details"
                    echo -e "${CYAN}-----------------------------------------------${NC}"
                    echo "$result" | awk -F'|' '{
                        print "  ID:          " $1
                        print "  Name:        " $2
                        print "  Phone:       " $3
                        print "  Email:       " $4
                        print "  Address:     " $5
                        print "  County:      " $6
                        print "  DOB:         " $7
                        print "  Doctor:      " $8
                        print "  Department:  " $9
                        print "  Appt Date:   " $10
                        print "  Appt Time:   " $11
                        print "  Status:      " $12
                    }'
                    echo -e "${CYAN}-----------------------------------------------${NC}"
                fi
            fi
            echo ""
            echo -e "${YELLOW}Press Enter to return to menu...${NC}"
            read pause
            break
            ;;

            "Add Appointment")
                # source runs add.sh in the same shell process as menu.sh
                # This ensures exit 0 in add.sh exits the whole system rather
                # than just the child process - unlike calling ./add.sh directly
                source ./add.sh
                break
                ;;

            "Search Appointments")
                # source runs search.sh in the same process so exit 0 exits the whole system
                source ./search.sh
                break
                ;;

            "Remove Appointment")
                # source runs remove.sh in the same process so exit 0 exits the whole system
                source ./remove.sh
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
                # Catch Q or q typed instead of a number
                if [ "$REPLY" = "Q" ] || [ "$REPLY" = "q" ]
                then
                    echo -e "${RED}"
                    echo "-----------------------------------------------"
                    echo "   YOU CHOSE TO EXIT, GOODBYE $USER!           "
                    echo "-----------------------------------------------"
                    echo -e "${NC}"
                    exit 0
                fi
                # M at the main menu just redraws it
                if [ "$REPLY" = "M" ] || [ "$REPLY" = "m" ]
                then
                    break
                fi
                echo -e "${RED}Invalid option. Please try again.${NC}"
                ;;

        esac
    done
done