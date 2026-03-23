# Hospital Appointment Management System
### Higher Diploma in Computer Science
### Author: Rachel Gillespie | Student ID: 20118715
### Module: Computer Systems | Lecturer: Caroline Cahill

---

## Video Demonstration
[Add your video URL here]

---

## Project Overview
This project is a Linux Bash Shell Scripting assessment which creates a
Hospital Appointment Management System. The system allows users to manage
patient appointment records through a menu-driven interface, with options
to add, view, search and remove appointments.

The system was developed and tested on WSL Ubuntu using VS Code.

---

## System Requirements
- Linux/Unix environment (developed and tested on WSL Ubuntu)
- Bash shell
- No additional dependencies required

---

## How to Run

1. Clone or download all files into the same directory
2. Make all scripts executable:
   chmod 755 menu.sh add.sh search.sh remove.sh
3. Run the main menu:
   ./menu.sh

---

## Files Included

| File | Description |
|---|---|
| `menu.sh` | Main menu script - entry point for the system |
| `add.sh` | Add a new appointment record with full validation |
| `search.sh` | Search appointments by Name, Department or Status |
| `remove.sh` | Remove a single record by ID or multiple by Status |
| `appointments.txt` | Data file storing all appointment records |
| `README.md` | This file |

---

## Data Structure
Records are stored in `appointments.txt` using a pipe-delimited format.
A pipe delimiter was chosen over a comma because patient addresses contain
commas which would break a standard CSV format.
```
ID|Name|Phone|Email|Address|County|DOB|Doctor|Department|AppointmentDate|AppointmentTime|Status
```

Example:
```
P001|John Murphy|0871234567|john.murphy@email.com|14 Oak Lane, Tralee|Kerry|15/03/1985|Dr. O'Brien|Cardiology|22/04/2026|10:30|Confirmed
```

---

## Features

### View All Appointments
- Displays all records in formatted, aligned columns using printf and awk
- Shows a message if no appointments exist

### View Specific Appointment
- Allows the user to view a single record by Patient ID
- Displays all fields in a labelled format

### Add Appointment
- Auto-generates a unique Patient ID (P001, P002 etc.) using wc -l and printf
- Validates all fields before saving:
  - Phone: must be 10 digits starting with 08
  - Email: must contain @ and . in correct format
  - DOB and Appointment Date: must be DD/MM/YYYY format
  - Appointment Time: must be HH:MM format
  - Status: accepts Confirmed, Pending or Cancelled (case insensitive)
- Checks for duplicate records by matching Name and Phone together
- Displays a review screen before saving where the user can edit any field
- Confirms with user before writing to file using >>

### Search Appointments
- Search by Patient Name (field 2)
- Search by Department (field 9)
- Search by Status (field 12)
- All searches are case insensitive using tolower() in awk
- Field-specific searching prevents false matches across other fields
- Results displayed in a formatted, labelled layout
- Clear message returned if no results found

### Remove Appointments
- Displays all current appointments before presenting delete options
- Delete a single record by Patient ID using grep -v with ^ line anchoring
- Delete multiple records by Status using awk with !~ field-specific matching
- Displays matching records before deletion so user can verify
- Confirms with user before deleting with a clear cannot be undone warning
- Uses a temp file to avoid overwriting the data file while it is being read

---

## Navigation
- At any prompt, type Q to quit the system
- At any prompt, type M to return to the main menu
- Navigation is handled by a reusable check_navigation function in each script

---

## Error Handling
- Blank field validation on all inputs using -z
- Format validation on phone, email, dates and time using regex
- Q to quit the system from any prompt
- M to return to main menu from any prompt
- Invalid menu options caught and handled
- Empty file check before viewing or searching
- Duplicate record warning before adding
- Record existence check before deleting
- Deletion confirmation to prevent accidental data loss

---

## Technical Notes
- source is used instead of ./ to call subscripts so that exit commands
  apply to the whole system rather than just a child process
- $() syntax is used for command substitution throughout as per the
  tips sheet guidance
- ANSI colour codes are used for UI colour schemes, referenced from:
  ECMA International (1991) ECMA-48: Control Functions for Coded
  Character Sets. Available at: https://www.ecma-international.org/
  publications-and-standards/standards/ecma-48/

---

## Known Limitations
- Patient IDs are not reassigned after deletion so gaps may appear
  in the sequence (e.g. if P004 is deleted, P004 will never be reused)
- Searching Dr. in the doctor search returns all doctors as all share
  the Dr. prefix — a future improvement would be to search by surname only
- The system does not validate that appointment dates are in the future
- The display_record function is duplicated in search.sh and remove.sh —
  a future improvement would be to move shared functions into a
  separate utils.sh file sourced by each script

---

## Reflection
Reflecting on this project, the main new learning for me was understanding
how bash handles process scope. Specifically, I needed to use source instead
of ./ to call my subscripts so that exit commands applied to the whole system
rather than just the child process. This was a problem I encountered during
development and worked through until I found the solution.

I also learned about using awk to search specific fields in a pipe-delimited
file, which was important for preventing false matches during search and delete
operations. I also gained experience using functions to reduce repetition across
scripts, which made the code much cleaner and easier to maintain.

One challenge I ran into was Windows line ending issues when saving files in
VS Code on WSL. I resolved this using sed -i to strip the carriage return
characters that Windows adds automatically when saving files.

In terms of what I would improve going forward, I would implement the dirname
technique to allow a subfolder file structure to work correctly regardless of
where the script is called from. I would also move shared functions like
display_record into a separate utils.sh file that each script could source,
to avoid the duplication that currently exists between search.sh and remove.sh.
Additionally, I would add date validation to prevent appointment dates from
being set in the past, and I would improve the ID generation so that gaps in
the sequence are filled after a record is deleted. Finally, I would refine the
doctor search to strip the Dr. prefix before matching so that results return
on surname only.

---

## Notes
- All scripts must be in the same directory as appointments.txt
- Do not manually edit appointments.txt while the system is running
- Developed on WSL Ubuntu — if running on a different system run the
  following to fix any line ending issues:
  sed -i 's/\r//' menu.sh add.sh search.sh remove.sh
