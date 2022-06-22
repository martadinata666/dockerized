
FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y --no-install-recommends iperf3 && apt clean && rm -rf /var/lib/apt/lists/*
CMD ["iperf3","-s"]
