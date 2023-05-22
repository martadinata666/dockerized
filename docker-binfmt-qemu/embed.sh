#/bin/bash
set -eu

for i in *; do mv $i $i-static; done