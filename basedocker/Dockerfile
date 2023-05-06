FROM ubuntu:lunar
RUN apt-get update && apt-get install -qy git jq caddy ftpd sqlite3 php-sqlite3 alsa-utils pulseaudio avahi-utils sox libsox-fmt-mp3 php php-fpm php-curl php-xml php-zip icecast2 swig ffmpeg wget unzip curl cmake make bc libjpeg-dev zlib1g-dev python3-dev python3-pip python3-venv lsof libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev
WORKDIR /root
RUN curl https://pyenv.run | bash
RUN echo 'export PYENV_ROOT="/root/.pyenv"' >> ~/.profile && echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile && echo 'eval "$(pyenv init -)"' >> ~/.profile
ENV PATH="$PATH:/root/.pyenv/bin"
RUN eval "$(pyenv init -)"
RUN pyenv install 3.9.16
RUN pyenv virtualenv 3.9.16 py3.9