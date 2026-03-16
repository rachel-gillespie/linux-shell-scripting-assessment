#!/bin/bash
# Author: Rachel Gillespie
# Student ID: 20118715
# Course: Higher Diploma in Computer Science
# Description:
# A script that searches for an employee by name in employee.txt and displays their details.
# Uses awk for exact, case-insensitive matching on the name field (field 2).

# Display a sorted list of all employee names from field 2 of the file
# 'sort -u' sorts alphabetically and removes duplicates
echo "Employees: "
awk '{print $1 $2}' employee.txt | sort -u

# Prompt the user to enter a name from the list
echo "Choose an employee from the list above"
read name

# Check if the user entered nothing (empty input)
if [ -z "$name" ]
then
   echo "Error, invalid entry."
   exit 1  # Exit the script with an error code
fi

# Search for the employee using awk
# -v passes the shell variable $name into awk as the variable 'n'
# tolower() makes the comparison case-insensitive, so "frank" matches "Frank"
# $2 refers to the second field (the name column) in each line
record=$(awk -v n="$name" 'tolower($2)==tolower(n)' employee.txt)

# Check if a matching record was found
if [ -z "$record" ]
then
   echo "No record found for: $name"
else
   echo "Info for $name:"
   # Print specific fields from the matched record using awk
   # NF refers to the last field (expenses), which handles lines with extra spaces reliably.
   echo "$record" | awk '{print "ID:         " $1 "\nName:       " $2 "\nPosition:   " $3 "\nDepartment: " $4 "\nExpenses:     " $NF}'
fi

echo
echo "Returning to menu..."
sleep 2