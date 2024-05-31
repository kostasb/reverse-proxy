#!/bin/sh
usage="$(basename "$0") [-d] [-e] -- Run End to End tests.\nRequired parameter:\n -d CN"

while getopts d:h flag
do
    case "${flag}" in
        d) DOMAIN=${OPTARG};;
        h) echo "$usage"
            exit;;
    esac
done
if [ -z ${DOMAIN+x} ]; then echo "Error: missing domain parameter (-d)\n"; exit -1; fi
echo "Creating test environment"
docker build -t e2etests e2etests >/dev/null 2>&1
docker run -e DOMAIN=$DOMAIN -v ./e2etests:/scripts:rw e2etests