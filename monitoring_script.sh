#!/bin/bash

# Output file 
output_file="/home/sigmoid/monitoring/output.csv"
notification_file="/home/sigmoid/monitoring/notifications.txt"

# Run top command in batch mode, capture command, cpu percentage, memory, and timestamp for 10 seconds
top -b -n 1 -d 10 | awk -v OFS=',' '{if (NR > 7 && $9 > 5) print $12, $9, strftime("%Y-%m-%d %H:%M:%S")} ' > "$output_file"

# Analyze output and categorize commands into different colors, only for commands exceeding 5% or 10%
awk -F, '!seen[$1]++ {
    if($2 > 10) {
        color="\033[0;31m"; 
        notification="Exceeds 10%"
    } 
    else if($2 > 5) {
        color="\033[0;33m"; 
        notification="Exceeds 5%"
    } 
    else {
        next
    }
    
    # If the command is 'average:' or empty, skip the line
    if ($1 == "average:" || $1 == "") {
        next
    }
    
    printf "%-30s %-10s %s%-20s\033[0m\n", $1, $2, color, notification
}' "$output_file" > "$notification_file"

# Add the header to the notification file
echo "command,Cpu %,notification" > temp_file
cat "$notification_file" >> temp_file
mv temp_file "$notification_file"

# Print the header
printf "%-30s %-10s %-20s\n" "command" "Cpu %" "notification"

# Print and save the notification output
cat "$notification_file"



