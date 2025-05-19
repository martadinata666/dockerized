#!/bin/bash

# Prompt for database credentials
read -p "Enter Database Name: " DB_NAME
read -p "Enter Username: " DB_USER
read -s -p "Enter Password: " DB_PASS
echo

# Execute all ALTER TABLE statements in one query
mariadb -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -Bse "
SELECT CONCAT('ALTER TABLE \`', TABLE_NAME, '\` ROW_FORMAT=DYNAMIC;')
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '$DB_NAME'
AND ENGINE = 'InnoDB'
" | mariadb -u "$DB_USER" -p"$DB_PASS" "$DB_NAME"