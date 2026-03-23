#!/bin/bash
# Author:      Rachel Gillespie
# Student ID:  20118715
# Course:      Higher Diploma in Computer Science
# Description: Search script for the Hospital Appointment Management System.
#              Allows the user to search appointments by Name, Department or Status.

# ── Colours ────────────────────────────────────────────────────────────────────
# -e flag on echo enables colour codes (ANSI colour codes researched to improve UI)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Colour

# ── Navigation function ────────────────────────────────────────────────────────
# Called after every read statement to check if user wants to quit or
# return to main menu. Covered in Shell Programming II notes under "Functions"
check_navigation() {
    if [ "$1" = "Q" ] || [ "$1" = "q" ]
    then
        echo -e "${RED}Exiting system. Goodbye $USER!${NC}"
        exit 0
    fi
    if [ "$1" = "M" ] || [ "$1" = "m" ]
    then
        echo -e "${YELLOW}Returning to main menu...${NC}"
        return 1
    fi
    return 0
}

# ── Data file ──────────────────────────────────────────────────────────────────
APPOINTMENTS_FILE="appointments.txt"

# ── Check appointments file exists before attempting to search ─────────────────
if [ ! -f "$APPOINTMENTS_FILE" ]
then
    echo -e "${RED}Error: appointments.txt not found!${NC}"
    sleep 2
    return
fi

# ── Display record function ────────────────────────────────────────────────────
# Takes a single line from the file and prints each field with a label
# awk -F'|' splits each line by the pipe delimiter as covered in Shell Programming II
display_record() {
    echo "$1" | awk -F'|' '{
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
}

# ── Display results function ───────────────────────────────────────────────────
# Takes a results string and loops through each line calling display_record
# Avoids repeating the same loop pattern across all three search options
display_results() {
    # IFS= prevents leading/trailing whitespace being stripped from each line
    # -r prevents backslashes being interpreted as escape characters
    echo "$1" | while IFS= read -r line
    do
        echo -e "${CYAN}-----------------------------------------------${NC}"
        display_record "$line"
    done
    echo -e "${CYAN}-----------------------------------------------${NC}"
}

# ── Pause or menu function ─────────────────────────────────────────────────────
# Pauses after displaying results and checks if user wants to return to main menu
# Avoids repeating the same pause block after every search option
pause_or_menu() {
    echo ""
    echo -e "${YELLOW}Press Enter to search again or M to return to main menu...${NC}"
    read pause
    check_navigation "$pause"
    if [ $? -eq 1 ]; then return 1; fi
    return 0
}

# ── Search menu loop ───────────────────────────────────────────────────────────
while true
do
    clear
    echo -e "${CYAN}"
    echo "-----------------------------------------------"
    echo "           SEARCH APPOINTMENTS                 "
    echo "-----------------------------------------------"
    echo -e "${YELLOW}  At any prompt: (M) Main Menu  |  (Q) Quit   ${NC}"
    echo ""
    echo "  1. Search by Name"
    echo "  2. Search by Department"
    echo "  3. Search by Status"
    echo ""
    read -p "Please enter your choice: " choice

    check_navigation "$choice"
    if [ $? -eq 1 ]; then return; fi

    case $choice in

        1)
            # ── Search by Name ─────────────────────────────────────────────
            echo ""
            echo -e "${YELLOW}Enter patient name to search for:${NC}"
            read searchname

            check_navigation "$searchname"
            if [ $? -eq 1 ]; then return; fi

            if [ -z "$searchname" ]
            then
                echo -e "${RED}Search term cannot be blank!${NC}"
                sleep 1
                continue
            fi

            echo ""
            echo -e "${CYAN}-----------------------------------------------${NC}"
            echo "  Results for name: $searchname"
            echo -e "${CYAN}-----------------------------------------------${NC}"

            # awk -F'|' searches only field 2 (Name) using tolower() for case insensitivity
            # This avoids false matches where the search term appears in other fields
            results=$(awk -F'|' 'tolower($2) ~ tolower("'"$searchname"'")' "$APPOINTMENTS_FILE")

            if [ -z "$results" ]
            then
                echo -e "${RED}  No appointments found for: $searchname${NC}"
            else
                display_results "$results"
            fi
            ;;

        2)
            # ── Search by Department ───────────────────────────────────────
            echo ""
            echo -e "${YELLOW}Enter department to search for (e.g. Cardiology):${NC}"
            read searchdepartment

            check_navigation "$searchdepartment"
            if [ $? -eq 1 ]; then return; fi

            if [ -z "$searchdepartment" ]
            then
                echo -e "${RED}Search term cannot be blank!${NC}"
                sleep 1
                continue
            fi

            echo ""
            echo -e "${CYAN}-----------------------------------------------${NC}"
            echo "  Results for department: $searchdepartment"
            echo -e "${CYAN}-----------------------------------------------${NC}"

            # Search only field 9 (Department) using awk to avoid false matches
            # tolower() makes the search case insensitive
            results=$(awk -F'|' 'tolower($9) ~ tolower("'"$searchdepartment"'")' "$APPOINTMENTS_FILE")

            if [ -z "$results" ]
            then
                echo -e "${RED}  No appointments found for department: $searchdepartment${NC}"
            else
                display_results "$results"
            fi
            ;;

        3)
            # ── Search by Status ───────────────────────────────────────────
            echo ""
            echo -e "${YELLOW}Enter status to search for (Confirmed / Pending / Cancelled):${NC}"
            read searchstatus

            check_navigation "$searchstatus"
            if [ $? -eq 1 ]; then return; fi

            if [ -z "$searchstatus" ]
            then
                echo -e "${RED}Search term cannot be blank!${NC}"
                sleep 1
                continue
            fi

            echo ""
            echo -e "${CYAN}-----------------------------------------------${NC}"
            echo "  Results for status: $searchstatus"
            echo -e "${CYAN}-----------------------------------------------${NC}"

            # Search only field 12 (Status) using awk -F'|'
            # tolower() makes the search case insensitive
            results=$(awk -F'|' 'tolower($12) ~ tolower("'"$searchstatus"'")' "$APPOINTMENTS_FILE")

            if [ -z "$results" ]
            then
                echo -e "${RED}  No appointments found with status: $searchstatus${NC}"
            else
                display_results "$results"
            fi
            ;;

        *)
            # Catch any invalid menu input
            echo -e "${RED}Invalid option. Please choose 1, 2 or 3.${NC}"
            sleep 1
            ;;

    esac

    # Pause and check if user wants to return to main menu
    pause_or_menu
    if [ $? -eq 1 ]; then return; fi

done