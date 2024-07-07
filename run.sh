#!/usr/bin/env bash

# VARS
DATE=$(date +%Y-%m-%d)
DUE_DATE=$(date -d "+5 days" +%Y-%m-%d)
INVOICE_ID=$(grep -oP '(?<=invoice-id = ")[^"]*' invoice.toml)
YEAR=${INVOICE_ID%-*}  # extract the year
INVOICE_NUM=${INVOICE_ID#*-}   # extract the invoice number

# increment the invoice number by 1
(( INVOICE_NUM++ )) 

# pad the invoice number with leading zeros to 3 digits
NEW_INVOICE_NUM=$(printf "%03d" "$INVOICE_NUM")
NEW_INVOICE_ID="$YEAR-$NEW_INVOICE_NUM"


# replace the invoice number in TOML
sed -i "s/^\(invoice-id = \)\"[^\"]*\"/\1\"$NEW_INVOICE_ID\"/" invoice.toml
# replace the invoice dates in TOML
sed -i "
  s/^\(date = \)\"[^\"]*\"/\1\"$DATE\"/
  s/^\(delivery-date = \)\"[^\"]*\"/\1\"$DATE\"/
  s/^\(issuing-date = \)\"[^\"]*\"/\1\"$DATE\"/
  s/^\(due-date = \)\"[^\"]*\"/\1\"$DUE_DATE\"/
" invoice.toml

docker run --name typst -v $PWD:/root --rm 123marvin123/typst typst c main.typ invoice.pdf

./send-mail.sh "Invoice $NEW_INVOICE_ID" "Please find attached the invoice with details."

exit 0
