#!/usr/bin/env bash
# Install BirdNET script
set -x # Debugging
exec > >(tee -i installation-$(date +%F).txt) 2>&1 # Make log
set -e # exit installation if anything fails

BIRDNETDIR=/root/BirdNETx86_64
export BIRDNETDIR=$BIRDNETDIR

cd $BIRDNETDIR/scripts || exit 1

if [ "$(uname -m)" != "x86_64" ];then
  echo "BirdNETx86_64 requires a 64-bit OS.
It looks like your operating system is using $(uname -m),
but would need to be x86_64.
Please take a look at https://birdnetwiki.pmcgui.xyz for more
information"
  exit 1
fi

#Install/Configure /etc/birdnet/birdnet.conf
./install_config.sh || exit 1
./install_services.sh || exit 1
source /etc/birdnet/birdnet.conf

install_birdnet() {
  cd ~/BirdNETx86_64 || exit 1
  echo "Establishing a python virtual environment"
  eval "$(pyenv init -)"
  pyenv activate py3.9
  # python3 -m venv birdnet
  # source ./birdnet/bin/activate

  pip3 install gdown
  # Download the custom tensorflow wheel
  gdown --fuzzy 'https://drive.google.com/file/d/17MkCs6Tl4Zk0EhyKD-pqE5rmgBZbyP_S/view'
  pip3 install -U tensorflow-2.5.3-cp39-cp39-linux_x86_64.whl
  pip3 install -U -r /root/BirdNETx86_64/requirements.txt
}

[ -d ${RECS_DIR} ] || mkdir -p ${RECS_DIR} &> /dev/null

install_birdnet

cd $BIRDNETDIR/scripts || exit 1

./install_language_label.sh -l $DATABASE_LANG || exit 1

exit 0
