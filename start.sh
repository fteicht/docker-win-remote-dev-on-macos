#/bin/bash

# Create the vagrant Windows machine
cd windows-docker-machine && vagrant up --provider virtualbox 2019-box && cd ..

# Switch to Windows container
docker context use 2019-box

# Version string
ver=$(($1 == 16 ? 2019 : $1 == 17 ? 2022 : null))`if [ "$2" != "null" ]; then echo -py$2; fi`

# Build the Windows Build Tools container
docker build -t buildtools$ver:latest --build-arg build_tools_version=$1 --build-arg python_version=$2 -m 2GB .

# Run the Windows Build Tools container
docker run -it -p 2222:22 -v $3:C:/Users/DevUser/Work buildtools$ver
