# Stop the Windows Build Tools container
docker stop $(docker ps -a -q --filter ancestor=buildtools$(($1 == 16 ? 2019 : $1 == 17 ? 2022 : null)))

# Stop the vagrant Windows machine
cd windows-docker-machine && vagrant halt 2019-box && cd ..

# Switch back to Docker Desktop
docker context use default
