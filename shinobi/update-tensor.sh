curl -X POST \
     --fail \
     -F token=glptt-0050fd3a7a1a607b88f3c03c1e11f890e7c9328c \
     -F ref=master \
     -F variables[TYPE]=tensorflow \
     https://gitlab.ddyms.my.id/api/v4/projects/35/trigger/pipeline
