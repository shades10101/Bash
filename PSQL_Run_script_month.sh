#!/bin/bash
psql -U postgres -d db_name -f /temp/Script_name.sql -o /temp/Output.csv
mail -s "Email subject" -a /temp/Output.csv -r no-reply@example.com user@example.com < /dev/null
