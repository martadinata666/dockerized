FROM 192.168.0.2:5050/dedyms/debian:latest
ARG DOTNET_VERSION=8.0.100
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends git wget libicu72 && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
RUN sudo mkdir -p /opt/dotnet && \
    wget https://dot.net/v1/dotnet-install.sh && \
    chmod +x ./dotnet-install.sh && \
    sudo ./dotnet-install.sh -v $DOTNET_VERSION --install-dir /opt/dotnet
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV PATH="/opt/dotnet:/opt/dotnet/tools:$PATH"
RUN dotnet --version
