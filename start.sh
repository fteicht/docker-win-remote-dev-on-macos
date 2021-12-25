#/bin/bash

# Create the vagrant Windows machine
cd windows-docker-machine && vagrant up --provider virtualbox 2019-box && cd ..

# Switch to Windows container
docker context use 2019-box

# Build the Windows Build Tools container
docker build -t buildtools$(($1 == 16 ? 2019 : $1 == 17 ? 2022 : null)):latest --build-arg build_tools_version=$1 -m 2GB .

# Run the Windows Build Tools container
docker run -it -p 2222:22 -v $2:C:/Users/dockeruser buildtools$(($1 == 16 ? 2019 : $1 == 17 ? 2022 : null))
