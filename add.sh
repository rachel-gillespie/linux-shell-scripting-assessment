#!/bin/bash
# Author: Rachel Gillespie
# Student ID: 20118715
# Course: Higher Diploma in Computer Science
# Description:
# A script that adds a new contact record to contact.txt.
# Validates each field before accepting it, and asks for confirmation before saving.

# Check if contact.txt exists. If it does, confirm it's there; if not, create it with 'touch'
[ -f ./contact.txt ] && echo "contact.txt exists" || touch ./contact.txt

echo "Add New Contact:"

# 'count' tracks how many valid fields have been collected (0–5)
# The loop only advances count when valid input is entered, forcing re-entry on bad input
count=0
while [ $count -lt 5 ]
do
   # --- Step 1: Contact ID ---
   if [ $count -eq 0 ]
   then
      echo "Enter Contact ID : "
      read id

      # Validate that ID contains only digits using a regex
      if ! [[ "$id" =~ ^[0-9]+$ ]]
      then
         echo "Not a number, input a number please!"

      # Check if this ID already exists in the file by searching for it at the start of a line
      elif grep -q "^$id " contact.txt
      then
         echo "This ID already exists!"

      else
         count=$((count+1))  # Valid ID accepted, move to next field
      fi
   fi

   # --- Step 2: Contact Name ---
   if [ $count -eq 1 ]
   then
      echo "Enter Contact Name : "
      read name

      # Validate that name contains only letters and spaces
      if [[ "$name" =~ ^[a-zA-Z[:space:]]+$ ]]
      then
         count=$((count+1))
      else
         echo "Name should contain only letters and spaces!"
      fi
   fi

   # --- Step 3: Contact Position ---
   if [ $count -eq 2 ]
   then
      echo "Enter Contact Position : "
      read position

      # Validate that position contains only letters and spaces
      if [[ "$position" =~ ^[a-zA-Z[:space:]]+$ ]]
      then
         count=$((count+1))
      else
         echo "Position should contain only letters and spaces!"
      fi
   fi

   # --- Step 4: Department ---
   if [ $count -eq 3 ]
   then
      echo "Enter Department : "
      read department

      # Validate that department contains only letters and spaces
      if [[ "$department" =~ ^[a-zA-Z[:space:]]+$ ]]
      then
         count=$((count+1))
      else
         echo "Department should contain only letters and spaces!"
      fi
   fi

   # --- Step 5: Expenses ---
   if [ $count -eq 4 ]
   then
      echo "Enter Expenses : "
      read expenses

      # Validate that expenses is a number
      if ! [[ "$expenses" =~ ^[0-9]+$ ]]
      then
         echo "Not a number, input a number please!"
      else
         count=$((count+1))  # Valid expenses accepted, loop will now exit
      fi
   fi
done

# Re-display the entered data so the user can review before confirming
echo "----------- Entered Data ---------------------------------------------"
echo $id "" $name "" $position "" $department "" $expenses " "
echo "----------------------------------------------------------------------"

# Ask for confirmation before writing to the file
echo -n "Are you sure you want to add this contact (y/n) :"
read answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]
then
   echo "----------------------------------------------------------------------"
   echo $id "" $name "" $position "" $department "" $expenses "" "added successfully"
   echo "----------------------------------------------------------------------"

   # Append the new contact record to contact.txt
   echo "$id $name $position $department €$expenses" >> contact.txt
else
   echo "Contact has not been added"
fi

echo
echo "Returning to menu..."
sleep 2