curl -X POST \
     -F token=fae322a5a03b3f1a88f0c66657f9d4 \
     -F "ref=master" \
     -F "variables[TYPE]=git" \
     http://192.168.0.2:10000/api/v4/projects/47/trigger/pipeline