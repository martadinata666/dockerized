#!/bin/sh
set -e
if [ -e "/config/conf.json" ]; then
    sudo cp /config/conf.json conf.json
fi
if [ ! -e "./conf.json" ]; then
    echo "Creating conf.json"
    sudo cp conf.sample.json conf.json
else
    echo "conf.json already exists..."
fi
if [ ! -e "./conf.json" ]; then
    sudo cp conf.sample.json conf.json
fi
echo "TF_FORCE_GPU_ALLOW_GROWTH=true" > "./.env"
echo "#CUDA_VISIBLE_DEVICES=0,2" >> "./.env"
sudo cp conf.json /config/conf.json

# Execute Command
echo "Starting $PLUGIN_NAME plugin for Shinobi ..."
exec "$@"
