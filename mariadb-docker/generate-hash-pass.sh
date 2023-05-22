#!/bin/bash
echo -n "Password: " && (stty -echo && head -n 1 | tr -d '\n' && stty echo) | openssl sha1 -binary | openssl sha1 -hex | awk '{print "*"toupper($0)}'