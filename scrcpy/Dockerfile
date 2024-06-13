FROM 192.168.0.2:5050/dedyms/debian:dev
RUN sudo apt update && \
    sudo apt install -y ffmpeg libsdl2-2.0-0 adb wget \
                 gcc git pkg-config meson ninja-build libsdl2-dev \
                 libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
                 libswresample-dev libusb-1.0-0 libusb-1.0-0-dev
RUN git clone https://github.com/Genymobile/scrcpy && \
    cd scrcpy && \
    ./install_release.sh
