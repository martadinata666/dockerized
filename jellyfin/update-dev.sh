#!/bin/bash
curl -X POST \
     -F token=1aa8a4cbe75e45b34dfb50c5088d4a \
     -F ref=master \
     -F "variables[DEV]=dev-web" \
     http://192.168.0.2:10000/api/v4/projects/60/trigger/pipeline
#dev-web
#dev-dotnet
#dev-both