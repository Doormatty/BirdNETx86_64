FROM birdnetbase:v1
WORKDIR /root
RUN curl https://pyenv.run | bash
RUN echo 'export PYENV_ROOT="/root/.pyenv"' >> ~/.profile && echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile && echo 'eval "$(pyenv init -)"' >> ~/.profile
RUN exec "$SHELL"
ENV PATH="$PATH:/root/.pyenv/bin"
RUN pyenv install 3.9.16
RUN pyenv virtualenv 3.9.16 py3.9
RUN git clone https://github.com/Doormatty/BirdNETx86_64.git
WORKDIR /root/BirdNETx86_64/scripts
RUN ./install_birdnet.sh
