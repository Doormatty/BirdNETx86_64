#!/usr/bin/env bash
# Update BirdNETx86_64's Git Repo
source /etc/birdnet/birdnet.conf
trap 'exit 1' SIGINT SIGHUP

usage() { echo "Usage: $0 [-r <remote name>] [-b <branch name>]" 1>&2; exit 1; }

USER=$(awk -F: '/1000/ {print $1}' /etc/passwd)
HOME=$(awk -F: '/1000/ {print $6}' /etc/passwd)
BIRDNETDIR=/root/BirdNETx86_64/scripts

# Defaults
remote="origin"
branch="main"

while getopts ":r:b:" o; do
  case "${o}" in
    r)
      remote=${OPTARG}
      git -C /root/BirdNETx86_64 remote show $remote > /dev/null 2>&1
      ret_val=$?

      if [ $ret_val -ne 0 ]; then
        echo "Error: remote '$remote' not found. Add the upstream remote to your repository and try again."
        exit 1
      fi
      ;;
    b)
      branch=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

sudo_with_user () {
  set -x
  sudo -u $USER "$@"
  set +x
}

# Get current HEAD hash
commit_hash=$(sudo_with_user git -C /root/BirdNETx86_64 rev-parse HEAD)

# Reset current HEAD to remove any local changes
sudo_with_user git -C /root/BirdNETx86_64 reset --hard

# Fetches latest changes
sudo_with_user git -C /root/BirdNETx86_64 fetch $remote $branch

# Switches git to specified branch
sudo_with_user git -C /root/BirdNETx86_64 switch -C $branch --track $remote/$branch

# Prints out changes
sudo_with_user git -C /root/BirdNETx86_64 diff --stat $commit_hash HEAD

sudo systemctl daemon-reload
sudo ln -sf $BIRDNETDIR/* /usr/local/bin/

# The script below handles changes to the host system
# Any additions to the updater should be placed in that file.
sudo $BIRDNETDIR/update_birdnet_snippets.sh
