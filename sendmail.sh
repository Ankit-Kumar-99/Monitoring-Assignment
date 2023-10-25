#!/bin/bash

# Recipient email address
recipient_email="ankitkumar99work@gmail.com"

# Subject of the email
subject="Subject of the Email"

# Path to the formatted data file
formatted_data_file="/home/sigmoid/monitoring/notifications.txt"

# Send email with formatted data
{
    echo "To: $recipient_email"
    echo "Subject: $subject"
    echo "Content-Type: text/html"
    echo
    echo "<html><body>"
    cat "$formatted_data_file"
    echo "</body></html>"
} | /usr/sbin/sendmail -t

echo "Email sent successfully."

