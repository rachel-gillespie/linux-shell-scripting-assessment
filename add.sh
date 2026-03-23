#!/bin/bash
# Author:      Rachel Gillespie
# Student ID:  20118715
# Course:      Higher Diploma in Computer Science
# Description: Add appointment script for the Hospital Appointment Management System.
#              Allows the user to add a new appointment with full validation.

# ── Colours ────────────────────────────────────────────────────────────────────
# -e flag on echo enables colour codes (ANSI colour codes researched to improve UI)
# https://chrisyeh96.github.io/2020/03/28/terminal-colors.html
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

# ── Header ─────────────────────────────────────────────────────────────────────
clear
echo -e "${CYAN}"
echo "-----------------------------------------------"
echo "           ADD NEW APPOINTMENT                 "
echo "-----------------------------------------------"
echo -e "${YELLOW}  At any prompt: (M) Main Menu  |  (Q) Quit   ${NC}"
echo ""

# ── Auto-generate Patient ID ───────────────────────────────────────────────────
# wc -l counts the number of lines (records) already in the file
# expr adds 1 to get the next ID number
linecount=$(wc -l < "$APPOINTMENTS_FILE")
next=$(expr $linecount + 1)

# printf formats the ID as P001, P002 etc. padding with leading zeros
id=$(printf "P%03d" $next)
echo -e "${GREEN}Generated Patient ID: $id ${NC}"
echo ""

# ── Field collection loop ──────────────────────────────────────────────────────
# count tracks which field we are currently collecting
# The loop only advances count when valid input is entered,
# forcing the user to re-enter if input is invalid
count=1
while [ $count -lt 12 ]
do

    # --- Step 1: Patient Name ---
    if [ $count -eq 1 ]
    then
        echo -e "${YELLOW}Enter Patient Name (or M for Main Menu, Q to Quit):${NC}"
        read name

        check_navigation "$name"
		# $? checks the return code of check_navigation - 1 means M was pressed
		if [ $? -eq 1 ]; then return; fi

        # Check for blank input
        if [ -z "$name" ]
        then
            echo -e "${RED}Name cannot be blank!${NC}"
        # Validate that name contains only letters and spaces
        elif [[ "$name" =~ ^[a-zA-Z[:space:]]+$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}Name should contain only letters and spaces!${NC}"
        fi
    fi

    # --- Step 2: Patient Phone Number ---
    if [ $count -eq 2 ]
    then
        echo -e "${YELLOW}Enter Patient Phone Number (08XXXXXXXX):${NC}"
        read phone

        check_navigation "$phone"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$phone" ]
        then
            echo -e "${RED}Phone number cannot be blank!${NC}"
        # Validate that phone contains exactly 10 digits, starting with 08
        elif [[ $phone =~ ^08[0-9]{8}$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}Phone should be 10 digits and start with 08!${NC}"
        fi
    fi

    # --- Step 3: Patient Email ---
    if [ $count -eq 3 ]
    then
        echo -e "${YELLOW}Enter Patient Email (name@example.com):${NC}"
        read email

        check_navigation "$email"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$email" ]
        then
            echo -e "${RED}Email cannot be blank!${NC}"
        # Validate email contains @ and . as per Shell Programming notes
        elif [[ $email =~ ^[^@]+@[^@]+\.[^@]+$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}Email should be in the format name@example.com!${NC}"
        fi
    fi

    # --- Step 4: Patient Address ---
    if [ $count -eq 4 ]
    then
        echo -e "${YELLOW}Enter Patient Address:${NC}"
        read address

        check_navigation "$address"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$address" ]
        then
            echo -e "${RED}Address cannot be blank!${NC}"
        # Allow letters, numbers, spaces and commas for addresses like "14 Oak Lane, Tralee"
        elif [[ "$address" =~ ^[a-zA-Z0-9,[:space:]]+$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}Address should contain only letters, numbers, spaces and commas!${NC}"
        fi
    fi

    # --- Step 5: Patient County ---
    if [ $count -eq 5 ]
    then
        echo -e "${YELLOW}Enter Patient County:${NC}"
        read county

        check_navigation "$county"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$county" ]
        then
            echo -e "${RED}County cannot be blank!${NC}"
        # Validate that county contains only letters and spaces
        elif [[ "$county" =~ ^[a-zA-Z[:space:]]+$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}County should contain only letters and spaces!${NC}"
        fi
    fi

    # --- Step 6: Patient Date of Birth ---
    if [ $count -eq 6 ]
    then
        echo -e "${YELLOW}Enter Patient Date of Birth (DD/MM/YYYY):${NC}"
        read dob

        check_navigation "$dob"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$dob" ]
        then
            echo -e "${RED}Date of birth cannot be blank!${NC}"
        # Validate date format is DD/MM/YYYY
        elif [[ $dob =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}Date of birth should be in DD/MM/YYYY format!${NC}"
        fi
    fi

    # --- Step 7: Doctor ---
    if [ $count -eq 7 ]
    then
        echo -e "${YELLOW}Enter Doctor Name (e.g. Dr. OBrien):${NC}"
        read doctor

        check_navigation "$doctor"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$doctor" ]
        then
            echo -e "${RED}Doctor name cannot be blank!${NC}"
        # Allow letters, spaces and full stops for names like "Dr. O Brien"
        elif [[ "$doctor" =~ ^[a-zA-Z.[:space:]]+$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}Doctor name should contain only letters and spaces!${NC}"
        fi
    fi

    # --- Step 8: Department ---
    if [ $count -eq 8 ]
    then
        echo -e "${YELLOW}Enter Department:${NC}"
        read department

        check_navigation "$department"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$department" ]
        then
            echo -e "${RED}Department cannot be blank!${NC}"
        # Validate department contains only letters and spaces
        elif [[ "$department" =~ ^[a-zA-Z[:space:]]+$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}Department should contain only letters and spaces!${NC}"
        fi
    fi

    # --- Step 9: Appointment Date ---
    if [ $count -eq 9 ]
    then
        echo -e "${YELLOW}Enter Appointment Date (DD/MM/YYYY):${NC}"
        read apptdate

        check_navigation "$apptdate"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$apptdate" ]
        then
            echo -e "${RED}Appointment date cannot be blank!${NC}"
        # Validate date format is DD/MM/YYYY
        elif [[ $apptdate =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}Appointment date should be in DD/MM/YYYY format!${NC}"
        fi
    fi

    # --- Step 10: Appointment Time ---
    if [ $count -eq 10 ]
    then
        echo -e "${YELLOW}Enter Appointment Time (HH:MM):${NC}"
        read appttime

        check_navigation "$appttime"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$appttime" ]
        then
            echo -e "${RED}Appointment time cannot be blank!${NC}"
        # Validate time format is HH:MM
        elif [[ $appttime =~ ^[0-9]{2}:[0-9]{2}$ ]]
        then
            count=$(expr $count + 1)
        else
            echo -e "${RED}Appointment time should be in HH:MM format!${NC}"
        fi
    fi

    # --- Step 11: Status ---
    if [ $count -eq 11 ]
    then
        echo -e "${YELLOW}Enter Status (Confirmed / Pending / Cancelled):${NC}"
        read status

        check_navigation "$status"
        if [ $? -eq 1 ]; then return; fi

        if [ -z "$status" ]
        then
            echo -e "${RED}Status cannot be blank!${NC}"
        else
            # Convert input to lowercase for comparison so confirmed, Confirmed
            # and CONFIRMED are all accepted - tr converts to lowercase
            status_lower=$(echo "$status" | tr '[:upper:]' '[:lower:]')

            if [ "$status_lower" = "confirmed" ] || [ "$status_lower" = "pending" ] || [ "$status_lower" = "cancelled" ]
            then
                # Store with a capital first letter so the file stays consistent
                status=$(echo "$status_lower" | sed 's/./\u&/')
                count=$(expr $count + 1)
            else
                echo -e "${RED}Status must be Confirmed, Pending or Cancelled!${NC}"
            fi
        fi
    fi

done

    # ── Duplicate check ────────────────────────────────────────────────────────────
    # Check if a record with the same name AND phone already exists in the file
    # awk -F'|' checks field 2 (Name) and field 3 (Phone) together using tolower()
    # for case insensitive comparison - using both fields prevents false positives
    # where two patients legitimately share the same name
    duplicate=$(awk -F'|' 'tolower($2) == tolower("'"$name"'") && $3 == "'"$phone"'"' "$APPOINTMENTS_FILE")

    if [ ! -z "$duplicate" ]
    then
    echo ""
    echo -e "${CYAN}-----------------------------------------------${NC}"
    echo -e "${RED}   WARNING: Possible duplicate record found!   ${NC}"
    echo -e "${CYAN}-----------------------------------------------${NC}"
    # Display the existing matching record so the user can compare
    echo "$duplicate" | awk -F'|' '{
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
    echo ""
    echo -e "${YELLOW}A record with this name and phone number already exists.${NC}"
    echo -e "${YELLOW}Do you still want to add this appointment? (y/n):${NC}"
    read duplicate_answer

    check_navigation "$duplicate_answer"
    if [ $? -eq 1 ]; then return; fi

    if [ "$duplicate_answer" != "y" ] && [ "$duplicate_answer" != "Y" ]
    then
        echo -e "${RED}Appointment has not been added.${NC}"
        echo ""
        echo "Returning to menu..."
        sleep 2
        return
    fi
	fi

	# ── Review and edit before confirming ─────────────────────────────────────────
	# Re-display the entered data so the user can review before saving
	# The while true loop keeps redisplaying the review screen after each edit
	# until the user confirms with C or cancels with N
	while true
	do
    echo ""
    echo -e "${CYAN}-----------------------------------------------${NC}"
    echo "        PLEASE REVIEW YOUR ENTRY              "
    echo -e "${CYAN}-----------------------------------------------${NC}"
    echo "  1.  ID:          $id"
    echo "  2.  Name:        $name"
    echo "  3.  Phone:       $phone"
    echo "  4.  Email:       $email"
    echo "  5.  Address:     $address"
    echo "  6.  County:      $county"
    echo "  7.  DOB:         $dob"
    echo "  8.  Doctor:      $doctor"
    echo "  9.  Department:  $department"
    echo "  10. Appt Date:   $apptdate"
    echo "  11. Appt Time:   $appttime"
    echo "  12. Status:      $status"
    echo -e "${CYAN}-----------------------------------------------${NC}"
    echo ""
    echo -e "${YELLOW}Enter a field number to edit, (C) to confirm, or (N) to cancel:${NC}"
    read review

    check_navigation "$review"
    if [ $? -eq 1 ]; then return; fi

    # ── Confirm and save ───────────────────────────────────────────────────────
    if [ "$review" = "C" ] || [ "$review" = "c" ]
    then
        # Append the new record to appointments.txt using >> as per lecture notes
        echo "$id|$name|$phone|$email|$address|$county|$dob|$doctor|$department|$apptdate|$appttime|$status" >> "$APPOINTMENTS_FILE"
        echo ""
        echo -e "${GREEN}-----------------------------------------------${NC}"
        echo -e "${GREEN}   Appointment $id added successfully!         ${NC}"
        echo -e "${GREEN}-----------------------------------------------${NC}"
        break

    # ── Cancel ────────────────────────────────────────────────────────────────
    elif [ "$review" = "N" ] || [ "$review" = "n" ]
    then
        echo -e "${RED}Appointment has not been added.${NC}"
        break

    # ── Edit a specific field ──────────────────────────────────────────────────
    # User enters a field number to re-enter that field only
    # without having to restart the whole form
    elif [ "$review" = "2" ]
    then
        echo -e "${YELLOW}Enter new Patient Name:${NC}"
        read name
        check_navigation "$name"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$name" ]
        then
            echo -e "${RED}Name cannot be blank!${NC}"
        elif [[ "$name" =~ ^[a-zA-Z[:space:]]+$ ]]
        then
            echo -e "${GREEN}Name updated.${NC}"
        else
            echo -e "${RED}Name should contain only letters and spaces!${NC}"
            name=""
        fi

    elif [ "$review" = "3" ]
    then
        echo -e "${YELLOW}Enter new Phone Number (08XXXXXXXX):${NC}"
        read phone
        check_navigation "$phone"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$phone" ]
        then
            echo -e "${RED}Phone cannot be blank!${NC}"
        elif [[ $phone =~ ^08[0-9]{8}$ ]]
        then
            echo -e "${GREEN}Phone updated.${NC}"
        else
            echo -e "${RED}Phone should be 10 digits and start with 08!${NC}"
            phone=""
        fi

    elif [ "$review" = "4" ]
    then
        echo -e "${YELLOW}Enter new Email (name@example.com):${NC}"
        read email
        check_navigation "$email"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$email" ]
        then
            echo -e "${RED}Email cannot be blank!${NC}"
        elif [[ $email =~ ^[^@]+@[^@]+\.[^@]+$ ]]
        then
            echo -e "${GREEN}Email updated.${NC}"
        else
            echo -e "${RED}Email should be in the format name@example.com!${NC}"
            email=""
        fi

    elif [ "$review" = "5" ]
    then
        echo -e "${YELLOW}Enter new Address:${NC}"
        read address
        check_navigation "$address"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$address" ]
        then
            echo -e "${RED}Address cannot be blank!${NC}"
        elif [[ "$address" =~ ^[a-zA-Z0-9,[:space:]]+$ ]]
        then
            echo -e "${GREEN}Address updated.${NC}"
        else
            echo -e "${RED}Address should contain only letters, numbers, spaces and commas!${NC}"
            address=""
        fi

    elif [ "$review" = "6" ]
    then
        echo -e "${YELLOW}Enter new County:${NC}"
        read county
        check_navigation "$county"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$county" ]
        then
            echo -e "${RED}County cannot be blank!${NC}"
        elif [[ "$county" =~ ^[a-zA-Z[:space:]]+$ ]]
        then
            echo -e "${GREEN}County updated.${NC}"
        else
            echo -e "${RED}County should contain only letters and spaces!${NC}"
            county=""
        fi

    elif [ "$review" = "7" ]
    then
        echo -e "${YELLOW}Enter new Date of Birth (DD/MM/YYYY):${NC}"
        read dob
        check_navigation "$dob"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$dob" ]
        then
            echo -e "${RED}Date of birth cannot be blank!${NC}"
        elif [[ $dob =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]
        then
            echo -e "${GREEN}Date of birth updated.${NC}"
        else
            echo -e "${RED}Date of birth should be in DD/MM/YYYY format!${NC}"
            dob=""
        fi

    elif [ "$review" = "8" ]
    then
        echo -e "${YELLOW}Enter new Doctor Name (e.g. Dr. OBrien):${NC}"
        read doctor
        check_navigation "$doctor"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$doctor" ]
        then
            echo -e "${RED}Doctor name cannot be blank!${NC}"
        elif [[ "$doctor" =~ ^[a-zA-Z.[:space:]]+$ ]]
        then
            echo -e "${GREEN}Doctor updated.${NC}"
        else
            echo -e "${RED}Doctor name should contain only letters and spaces!${NC}"
            doctor=""
        fi

    elif [ "$review" = "9" ]
    then
        echo -e "${YELLOW}Enter new Department:${NC}"
        read department
        check_navigation "$department"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$department" ]
        then
            echo -e "${RED}Department cannot be blank!${NC}"
        elif [[ "$department" =~ ^[a-zA-Z[:space:]]+$ ]]
        then
            echo -e "${GREEN}Department updated.${NC}"
        else
            echo -e "${RED}Department should contain only letters and spaces!${NC}"
            department=""
        fi

    elif [ "$review" = "10" ]
    then
        echo -e "${YELLOW}Enter new Appointment Date (DD/MM/YYYY):${NC}"
        read apptdate
        check_navigation "$apptdate"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$apptdate" ]
        then
            echo -e "${RED}Appointment date cannot be blank!${NC}"
        elif [[ $apptdate =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]
        then
            echo -e "${GREEN}Appointment date updated.${NC}"
        else
            echo -e "${RED}Appointment date should be in DD/MM/YYYY format!${NC}"
            apptdate=""
        fi

    elif [ "$review" = "11" ]
    then
        echo -e "${YELLOW}Enter new Appointment Time (HH:MM):${NC}"
        read appttime
        check_navigation "$appttime"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$appttime" ]
        then
            echo -e "${RED}Appointment time cannot be blank!${NC}"
        elif [[ $appttime =~ ^[0-9]{2}:[0-9]{2}$ ]]
        then
            echo -e "${GREEN}Appointment time updated.${NC}"
        else
            echo -e "${RED}Appointment time should be in HH:MM format!${NC}"
            appttime=""
        fi

    elif [ "$review" = "12" ]
    then
        echo -e "${YELLOW}Enter new Status (Confirmed / Pending / Cancelled):${NC}"
        read status
        check_navigation "$status"
        if [ $? -eq 1 ]; then return; fi
        if [ -z "$status" ]
        then
            echo -e "${RED}Status cannot be blank!${NC}"
        else
            status_lower=$(echo "$status" | tr '[:upper:]' '[:lower:]')
            if [ "$status_lower" = "confirmed" ] || [ "$status_lower" = "pending" ] || [ "$status_lower" = "cancelled" ]
            then
                status=$(echo "$status_lower" | sed 's/./\u&/')
                echo -e "${GREEN}Status updated.${NC}"
            else
                echo -e "${RED}Status must be Confirmed, Pending or Cancelled!${NC}"
                status=""
            fi
        fi

    else
        # Field 1 is the auto-generated ID so it cannot be edited
        if [ "$review" = "1" ]
        then
            echo -e "${RED}Patient ID is auto-generated and cannot be edited.${NC}"
        else
            echo -e "${RED}Invalid option. Enter a field number (2-12), C to confirm or N to cancel.${NC}"
        fi
    fi

done

echo ""
echo "Returning to menu..."
sleep 2