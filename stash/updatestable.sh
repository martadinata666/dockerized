#!/bin/bash
curl -X POST \
     -F token=854853555575e0ec77e240feb37e44 \
     -F "ref=master" \
     -F "variables[VERSION]=v0.10.0" \
     https://gitlab.com/api/v4/projects/27566180/trigger/pipeline
