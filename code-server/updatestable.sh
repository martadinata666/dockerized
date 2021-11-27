#!/bin/sh
curl -X POST \
     -F token=9ad370d22dda5bc236f9aa030b699c \
     -F "ref=master" \
     -F "variables[CODE_RELEASE]=3.12.0" \
     https://gitlab.com/api/v4/projects/25438334/trigger/pipeline
