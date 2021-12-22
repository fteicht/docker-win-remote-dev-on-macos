# docker-win-remote-dev-on-macos
Set up a Windows Docker container with Openssh and Microsoft Visual Studio BuildTools on macOS host.
One use case can be to develop Windows application remotely from Visual Studio Code in a macOS host.

Here are the installation steps:

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads)
2. Clone the [Windows Docker Machine](https://github.com/StefanScherer/windows-docker-machine) repository and follow the "[Create the Docker Machine](https://github.com/StefanScherer/windows-docker-machine#create-the-docker-machine)" and "[Switch to Windows containers](https://github.com/StefanScherer/windows-docker-machine#switch-to-windows-containers)" steps.
3. Got to the root folder of the cloned `docker-win-remote-dev-on-macos` repository
4. Build the Docker container with the following shell command: `docker build -t buildtools2022:latest -m 2GB .`
5. Run the Docker container that will launch a SSH server on port 2222 of your macOS host with the following shell command: `docker run -d -p 2222:22 buildtools2022`
6. You can connect to the Windows machine as user `dockeruser` with password `Passw0rd`. You have two options:
   * Either in the terminal with the following shell command: `ssh -p 2222 dockeruser@$(docker context inspect 2019-box | jq -r '.[0].Endpoints.docker.Host | .[6:] | .[:-5]')`
   * Or using the Remote Explorer extension of Visual Studio Code. In this case, you need first to get the IP address of your Windows machine by issuing the following shell command: `echo $(docker context inspect 2019-box | jq -r '.[0].Endpoints.docker.Host | .[6:] | .[:-5]')`. Then, copy the resulting IP address and add the following entry in your `~/.ssh/config` file, after which your `buildtools2022` Windows machine will be accessible from the VSCode's Remote Explorer:

```
Host buildtools2022
  HostName <your-Windows-machine-IP>
  User dockeruser
  Port 2222
```
