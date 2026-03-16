#!/bin/bash
# Author: Rachel Gillespie
# Student ID: 20118715
# Course: Higher Diploma in Computer Science
# Description:
# The main menu script for the Employee Management System.
# Presents the user with options to Add, View, Search, or Quit.

# Display a welcome banner using the $USER environment variable (current logged-in user)
echo "-----------------------------------------------"
echo "            WELCOME $USER                      "
echo "-----------------------------------------------"

# PS3 is a bash variable that sets the prompt text for 'select' menus
PS3='Please enter your choice: '

# Define the menu options in an array
options=("Add" "View" "Search" "Remove" "Quit")

# Outer loop keeps the menu running after each action, so the user can make multiple choices
while true
do
    # 'select' generates a numbered menu from the options array and waits for input
    select opt in "${options[@]}"
    do
        case $opt in
            "Add")
                # Call the add.sh script to add a new employee
                ./add.sh
                break  # Break out of the select loop to redisplay the menu
                ;;
            "View")
                # Display all records from employee.txt
                echo
                echo "Employee Records:"
                echo "-----------------------------------"
                cat employee.txt
                echo "-----------------------------------"
                break
                ;;
            "Search")
                # Call the search.sh script to search for an employee
                ./search.sh
                break
                ;;
            "Remove")
                # Call the remove.sh script to remove an employee
                ./remove.sh
                break
                ;;
            "Quit")
                # Exit the program with a goodbye message
                echo "-----------------------------------------------"
                echo "  YOU CHOSE TO EXIT, GOODBYE $USER!            "
                echo "-----------------------------------------------"
                exit 0
                ;;
            *)
                # Catch any invalid input that doesn't match the menu options
                echo "Invalid option. Please try again."
                ;;
        esac
    done
done