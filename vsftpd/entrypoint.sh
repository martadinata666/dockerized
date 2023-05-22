#!/bin/bash

echo "listen_port=${LISTEN_PORT}" >> /etc/vsftpd.conf
echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd.conf
echo "pasv_max_port=${PASV_MAX_PORT}" >> /etc/vsftpd.conf
echo "pasv_min_port=${PASV_MIN_PORT}" >> /etc/vsftpd.conf

# Get log file path
#export LOG_FILE=`grep xferlog_file /etc/vsftpd.conf|cut -d= -f2`

# stdout server info
#/bin/ln -sf /dev/stdout $LOG_FILE
# Run vsftpd:
&>/dev/null /usr/sbin/vsftpd /etc/vsftpd.conf
