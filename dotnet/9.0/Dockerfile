FROM 192.168.0.2:6060/dedyms/debian:latest
ARG DOTNET_VERSION=9.0
RUN curl -L https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -o packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    sudo apt update && \
    sudo apt install -y --no-install-recommends dotnet-sdk-${DOTNET_VERSION} && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
RUN dotnet --version
