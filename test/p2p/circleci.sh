#! /bin/bash
set -eux

# Get the directory of where this script is.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

LOGS_DIR="$DIR/../logs"
echo
echo "* [$(date +"%T")] cleaning up $LOGS_DIR"
rm -rf "$LOGS_DIR"
mkdir -p "$LOGS_DIR"

echo
echo "* [$(date +"%T")] starting rsyslog container"
docker rm -f rsyslog || true
docker run -d -v "$LOGS_DIR:/var/log/" -p 127.0.0.1:5514:514/udp --name rsyslog voxxit/rsyslog

echo
echo "* [$(date +"%T")] running p2p tests on a local docker network"
bash "$DIR/test.sh"
