#FROM node:12.18.3-buster
FROM 192.168.0.2:5050/dedyms/node:lts-dev as builder

#RUN sudo apt update -y && \
#    sudo apt install wget curl net-tools python3 python-is-python3 openjdk-11-jdk-headless -y --no-install-recommends && \
#    wget -c https://github.com/bazelbuild/bazel/releases/download/3.1.0/bazel_3.1.0-linux-x86_64.deb && \
#    sudo apt install -y ./bazel*.deb

RUN sudo apt update -y && \
    sudo apt install -y --no-install-recommends wget curl net-tools python3 python-is-python3 openjdk-11-jdk-headless python3-numpy libdnnl-dev && \
    wget -c https://github.com/bazelbuild/bazel/releases/download/3.7.2/bazel_3.7.2-linux-x86_64.deb && \
    sudo apt install -y ./bazel*.deb && \
    sudo npm -g install @mapbox/node-pre-gyp
RUN mkdir -p shinobi
COPY --chown=$CONTAINERUSER:$CONTAINERUSER 4.1.0 shinobi/tensorflow
RUN wget https://gitlab.com/Shinobi-Systems/Shinobi/-/raw/dev/plugins/pluginBase.js -O $HOME/shinobi/pluginBase.js
RUN wget https://gitlab.com/Shinobi-Systems/Shinobi/-/raw/dev/plugins/pluginBase.js -O $HOME/shinobi/tensorflow/pluginBase.js
RUN wget https://gitlab.com/Shinobi-Systems/Shinobi/-/raw/dev/plugins/pluginCheck.js -O $HOME/shinobi/pluginCheck.js
RUN wget https://gitlab.com/Shinobi-Systems/Shinobi/-/raw/dev/plugins/pluginCheck.js -O $HOME/shinobi/tensorflow/pluginCheck.js
RUN wget https://gitlab.com/Shinobi-Systems/Shinobi/-/raw/dev/tools/modifyConfigurationForPlugin.js -O $HOME/shinobi/tensorflow/modifyConfigurationForPlugin.js
WORKDIR $HOME/shinobi/tensorflow
RUN npm -d --force --cache=/dev/shm install
RUN git clone --depth=1 -b v2.7.0 https://github.com/tensorflow/tensorflow $HOME/tensorflow-src
WORKDIR $HOME/tensorflow-src
RUN bazel build --config=mkl -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-DDNNL\_ENABLE\_ITT\_TASKS=True //tensorflow/tools/lib_package:libtensorflow && \
    cp bazel-bin/tensorflow/tools/lib_package/libtensorflow.tar.gz $HOME/shinobi/tensorflow/node_modules/@tensorflow/tfjs-node/deps/
WORKDIR $HOME/shinobi/tensorflow/node_modules/@tensorflow/tfjs-node/deps
RUN tar -xf libtensorflow.tar.gz && \
    rm libtensorflow.tar.gz


#TF_CPP_MIN_LOG_LEVEL=2 \
FROM 192.168.0.2:5050/dedyms/node:lts
ENV TFJS_HW=cpu \
    PLUGIN_NAME=Tensorflow \
    PLUGIN_HOST=localhost \
    PLUGIN_PORT=8080 \
    PLUGIN_HOST_PORT=8082 \
    PLUGIN_KEY=RANDOM \
    PLUGIN_MODE=client \
    PM2_HOME=/shinobi/tensorflow/pm2

RUN sudo apt update && \
    sudo apt install libdnnl2 && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*

RUN sudo npm -g install pm2 

COPY --from=builder --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/shinobi /shinobi
WORKDIR /shinobi/tensorflow
RUN sudo mkdir -p /config && sudo chown $CONTAINERUSER:$CONTAINERUSER /config
EXPOSE 8082
USER $CONTAINERUSER
ENTRYPOINT ["/shinobi/tensorflow/init.sh"]
CMD ["pm2-docker", "pm2.yml"]
