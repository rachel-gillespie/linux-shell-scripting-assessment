#!/bin/bash
# Author:      Rachel Gillespie
# Student ID:  20118715
# Course:      Higher Diploma in Computer Science
# Description: Remove script for the Hospital Appointment Management System.
#              Allows the user to delete a single record by ID or
#              multiple records by Status.

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

# ── Check appointments file exists before attempting to remove ─────────────────
if [ ! -f "$APPOINTMENTS_FILE" ]
then
    echo -e "${RED}Error: appointments.txt not found!${NC}"
    sleep 2
    return
fi

# ── Display record function ────────────────────────────────────────────────────
# Takes a single line from the file and prints each field with a label
# awk -F'|' splits each line by the pipe delimiter as covered in Shell Programming II
# Note: display_record is also defined in search.sh - a future improvement would be
# to move shared functions into a separate utils.sh file and source it into each script
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
# Avoids repeating the same loop pattern for both delete options
display_results() {
    # IFS= prevents leading/trailing whitespace being stripped from each line
    # -r prevents backslashes being interpreted as escape characters
    echo "$1" | while IFS= read -r line
    do
        display_record "$line"
        echo -e "${CYAN}-----------------------------------------------${NC}"
    done
}

# ── Pause or menu function ─────────────────────────────────────────────────────
# Pauses after an action and checks if user wants to return to main menu
# Avoids repeating the same pause block after every delete option
pause_or_menu() {
    echo ""
    echo -e "${YELLOW}Press Enter to continue or M to return to main menu...${NC}"
    read pause
    check_navigation "$pause"
    if [ $? -eq 1 ]; then return 1; fi
    return 0
}

# ── Remove menu loop ───────────────────────────────────────────────────────────
while true
do
    clear
    echo -e "${CYAN}"
    echo "-----------------------------------------------"
    echo "           REMOVE APPOINTMENTS                 "
    echo "-----------------------------------------------"
    echo -e "${YELLOW}  At any prompt: (M) Main Menu  |  (Q) Quit   ${NC}"
    echo ""
    echo "  1. Delete Single Record by Patient ID"
    echo "  2. Delete Multiple Records by Status"
    echo ""

    # Display all current appointments so user can see what exists before deleting
    # Uses the same printf and awk technique as menu.sh for aligned columns
    if [ ! -s "$APPOINTMENTS_FILE" ]
    then
        echo -e "${RED}No appointments found.${NC}"
        echo ""
    else
        printf "%-6s %-18s %-12s %-30s %-30s %-12s %-12s %-16s %-15s %-12s %-5s %-12s\n" \
            "ID" "Name" "Phone" "Email" "Address" "County" "DOB" "Doctor" "Department" "Date" "Time" "Status"
        echo -e "${CYAN}$(printf '%0.s-' {1..188})${NC}"
        awk -F'|' '{printf "%-6s %-18s %-12s %-30s %-30s %-12s %-12s %-16s %-15s %-12s %-5s %-12s\n", \
            $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' "$APPOINTMENTS_FILE"
        echo -e "${CYAN}$(printf '%0.s-' {1..188})${NC}"
    fi
    echo ""
    read -p "Please enter your choice: " choice

    check_navigation "$choice"
    if [ $? -eq 1 ]; then return; fi

    case $choice in

        1)
            # ── Delete Single Record by Patient ID ─────────────────────────
            echo ""
            echo -e "${YELLOW}Enter Patient ID to delete (e.g. P001):${NC}"
            read deleteid

            check_navigation "$deleteid"
            if [ $? -eq 1 ]; then return; fi

            if [ -z "$deleteid" ]
            then
                echo -e "${RED}Patient ID cannot be blank!${NC}"
                sleep 1
                continue
            fi

            # Search only field 1 (ID) using awk with exact match ==
            # == prevents partial matches e.g. P001 matching P0011
            result=$(awk -F'|' '$1 == "'"$deleteid"'"' "$APPOINTMENTS_FILE")

            # Check if record exists before attempting to delete
            if [ -z "$result" ]
            then
                echo -e "${RED}No appointment found with ID: $deleteid${NC}"
                echo ""
                echo -e "${YELLOW}Press Enter to try again...${NC}"
                read pause
                check_navigation "$pause"
                if [ $? -eq 1 ]; then return; fi
                continue
            fi

            # Show the record to the user before asking for confirmation
            echo ""
            echo -e "${CYAN}-----------------------------------------------${NC}"
            echo "  Record to be deleted:"
            echo -e "${CYAN}-----------------------------------------------${NC}"
            display_record "$result"
            echo -e "${CYAN}-----------------------------------------------${NC}"
            echo ""

            # Ask for confirmation before deleting
            echo -e "${RED}Are you sure you want to delete this record? This cannot be undone! (y/n):${NC}"
            read confirm

            check_navigation "$confirm"
            if [ $? -eq 1 ]; then return; fi

            if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]
            then
                # grep -v keeps every line that does NOT match the ID
                # ^ anchors the match to the start of the line ensuring only field 1
                # is matched - this is the phonerm technique from Shell Programming II notes
                # Output is written to a temp file first then moved to replace the original
                # to avoid overwriting the file while it is still being read
                grep -v "^$deleteid|" "$APPOINTMENTS_FILE" > /tmp/appointments_temp.txt
                mv /tmp/appointments_temp.txt "$APPOINTMENTS_FILE"
                echo ""
                echo -e "${GREEN}-----------------------------------------------${NC}"
                echo -e "${GREEN}   Record $deleteid deleted successfully!       ${NC}"
                echo -e "${GREEN}-----------------------------------------------${NC}"
            else
                echo -e "${YELLOW}Deletion cancelled.${NC}"
            fi
            ;;

        2)
            # ── Delete Multiple Records by Status ──────────────────────────
            echo ""
            echo -e "${YELLOW}Enter Status to delete (Confirmed / Pending / Cancelled):${NC}"
            read deletestatus

            check_navigation "$deletestatus"
            if [ $? -eq 1 ]; then return; fi

            if [ -z "$deletestatus" ]
            then
                echo -e "${RED}Status cannot be blank!${NC}"
                sleep 1
                continue
            fi

            # Find all records matching the status in field 12 only
            # tolower() makes the search case insensitive
            results=$(awk -F'|' 'tolower($12) ~ tolower("'"$deletestatus"'")' "$APPOINTMENTS_FILE")

            # Check if any records were found before attempting to delete
            if [ -z "$results" ]
            then
                echo -e "${RED}No appointments found with status: $deletestatus${NC}"
                echo ""
                echo -e "${YELLOW}Press Enter to try again...${NC}"
                read pause
                check_navigation "$pause"
                if [ $? -eq 1 ]; then return; fi
                continue
            fi

            # Count how many records will be deleted so user knows what to expect
            count=$(echo "$results" | wc -l)

            # Show all matching records to the user before asking for confirmation
            echo ""
            echo -e "${CYAN}-----------------------------------------------${NC}"
            echo "  The following $count record(s) will be deleted:"
            echo -e "${CYAN}-----------------------------------------------${NC}"
            display_results "$results"
            echo ""

            # Ask for confirmation before deleting
            echo -e "${RED}Are you sure you want to delete all $count record(s)? This cannot be undone! (y/n):${NC}"
            read confirm

            check_navigation "$confirm"
            if [ $? -eq 1 ]; then return; fi

            if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]
            then
                # awk !~ keeps every line where field 12 does NOT match the status
                # Searching field 12 specifically prevents a patient named "Confirmed"
                # from being accidentally deleted - addresses the Kerry example in the spec
                awk -F'|' 'tolower($12) !~ tolower("'"$deletestatus"'")' "$APPOINTMENTS_FILE" > /tmp/appointments_temp.txt
                mv /tmp/appointments_temp.txt "$APPOINTMENTS_FILE"
                echo ""
                echo -e "${GREEN}-----------------------------------------------${NC}"
                echo -e "${GREEN}   $count record(s) deleted successfully!       ${NC}"
                echo -e "${GREEN}-----------------------------------------------${NC}"
            else
                echo -e "${YELLOW}Deletion cancelled.${NC}"
            fi
            ;;

        *)
            # Catch any invalid menu input
            echo -e "${RED}Invalid option. Please choose 1 or 2.${NC}"
            sleep 1
            ;;

    esac

    # Pause and check if user wants to return to main menu
    pause_or_menu
    if [ $? -eq 1 ]; then return; fi

done