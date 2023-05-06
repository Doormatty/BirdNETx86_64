FROM ubuntu:lunar
RUN apt-get update && apt-get install -qy git jq caddy ftpd sqlite3 php-sqlite3 alsa-utils pulseaudio avahi-utils sox libsox-fmt-mp3 php php-fpm php-curl php-xml php-zip icecast2 swig ffmpeg wget unzip curl cmake make bc libjpeg-dev zlib1g-dev python3-dev python3-pip python3-venv lsof
WORKDIR /root
RUN git clone https://github.com/Doormatty/BirdNETx86_64.git
WORKDIR /root/BirdNETx86_64/scripts

