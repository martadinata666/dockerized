# Build base systemd
FROM 192.168.0.2:5050/dedyms/debian:latest AS base
ARG TARGETPLATFORM
ARG IMAGEMAGICK_VERSION=7.1.0-17
ENV DEBIAN_FRONTEND=noninteractive

# Install python
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip \
  && pip3 install --no-cache-dir pyvips==2.1.15 cmake==3.21.2
  && apt-get install -y --no-install-recommends \
		build-essential \
		bzip2 \
		curl \
		ffmpeg \
		git \
		libboost-all-dev \
		libcfitsio-dev \ 
		libexif-dev \
		libexpat-dev \
		libexpat1-dev \ 
		libgif-dev \
		libgl1-mesa-glx \
		libglib2.0-dev \
		libgsf-1-dev \ 
		libheif-dev \
		libimage-exiftool-perl \
		libimagequant-dev \
		libjpeg-dev \
		liblapack-dev \
		liblcms2-dev \
		libmagic1 \
		libopenblas-dev \
		libopenexr-dev \ 
		liborc-dev \
		libpng-dev \
		libpq-dev \
		libraw-dev \
		librsvg2-dev \
		libsm6 \
		libtiff5-dev \ 
		libtool \ 
		libtool-bin \
		libwebp-dev \
		libxrender-dev \
		pkg-config \ 
		python3-dev \
		python3-pip \
		swig \
		unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/LibRaw/LibRaw && \
	cd /LibRaw && \ 
	autoreconf --install && \
	./configure && \
	make && \
	make install && \
    curl -SL https://www.imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz | tar -zx && \
	cd /ImageMagick-${IMAGEMAGICK_VERSION} && \
	./configure --with-modules && \
	make install && \
	ldconfig /usr/local/lib

# Torch & torchvision, arm64 from different localtion    
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then pip3 install --no-cache-dir torch torchvision -f https://torch.kmtea.eu/whl/stable.html; else pip3 install --no-cache-dir torch torchvision; fi

