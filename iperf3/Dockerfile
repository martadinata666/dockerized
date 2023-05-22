FROM 192.168.0.2:5050/dedyms/debian:latest
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends iperf3 && \
    sudo apt clean && sudo \
    sudo rm -rf /var/lib/apt/lists/*
CMD ["iperf3","-s"]
