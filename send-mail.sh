#!/usr/bin/env bash

# Configure sendmail by checking
# https://web.archive.org/web/20240206023834/https://tecadmin.net/configuring-sendmail-through-the-external-smtp-relay/
# Set email settings
FROM="YOUR_EMAIL@YOUR_DOMAIN.com"
TO="YOUR_CLIENT@CLIENT_DOMAIN.com"
CC="IF YOU WANT TO CC"
SUBJECT="SOMETHING IMPORTANT"
BODY="Please find attached the invoice with details."
PDF_ATTACHMENT="invoice.pdf"

# Using positional arguments
SUBJECT="${1:-$SUBJECT}"
BODY="${2:-$BODY}"

# Create a temporary file for the email
TMP_EMAIL_FILE="mail.eml"

# Create the email headers
echo "From: $FROM" >> $TMP_EMAIL_FILE
echo "To: $TO" >> $TMP_EMAIL_FILE
echo "CC: $CC" >> $TMP_EMAIL_FILE
echo "Disposition-Notification-To: $TO" >> TMP_EMAIL_FILE
echo "Subject: $SUBJECT" >> $TMP_EMAIL_FILE
echo "MIME-Version: 1.0" >> $TMP_EMAIL_FILE
echo "Content-Type: multipart/mixed; boundary=\"123467890ABCDE\"" >> $TMP_EMAIL_FILE
echo "" >> $TMP_EMAIL_FILE

# Add the email body
echo "--123467890ABCDE" >> $TMP_EMAIL_FILE
echo "Content-Type: text/plain; charset=US-ASCII" >> $TMP_EMAIL_FILE
echo "Content-Transfer-Encoding: 7bit" >> $TMP_EMAIL_FILE
echo "Content-Disposition: inline" >> $TMP_EMAIL_FILE
echo "" >> $TMP_EMAIL_FILE
echo "$BODY" >> $TMP_EMAIL_FILE
echo "" >> $TMP_EMAIL_FILE

# Add the PDF attachment
echo "--123467890ABCDE" >> $TMP_EMAIL_FILE
echo "Content-Type: application/pdf; name=\"$PDF_ATTACHMENT\"" >> $TMP_EMAIL_FILE
echo "Content-Transfer-Encoding: base64" >> $TMP_EMAIL_FILE
echo "Content-Disposition: attachment; filename=\"$PDF_ATTACHMENT\"" >> $TMP_EMAIL_FILE
echo "" >> $TMP_EMAIL_FILE
base64 -w 0 "$PDF_ATTACHMENT" >> $TMP_EMAIL_FILE
echo "" >> $TMP_EMAIL_FILE
echo "--123467890ABCDE--" >> $TMP_EMAIL_FILE

# Send the email using sendmail
/usr/sbin/sendmail -i -t < $TMP_EMAIL_FILE

# Remove the temporary file
rm $TMP_EMAIL_FILE

exit 0
