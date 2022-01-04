# Version string
ver=$(($1 == 16 ? 2019 : $1 == 17 ? 2022 : null))`if [ "$2" != "null" ]; then echo -py$2; fi`

# Stop the Windows Build Tools container
docker stop $(docker ps -a -q --filter ancestor=buildtools$ver)

# Stop the vagrant Windows machine
cd windows-docker-machine && vagrant halt 2019-box && cd ..

# Switch back to Docker Desktop
docker context use default
