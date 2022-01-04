# docker-win-remote-dev-on-macos
Set up a Windows Docker container with Openssh, Git, Microsoft Visual Studio BuildTools, and optionally Python (MiniConda), on macOS host.
One use case can be to develop Windows applications remotely from Visual Studio Code in a macOS host.

Here are the installation steps:

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads)
2. Got to the root folder of the cloned `docker-win-remote-dev-on-macos` repository (this repository)
3. Fetch the [Windows Docker Machine](https://github.com/StefanScherer/windows-docker-machine) repository: `git submodule update --init --recursive`
4. Run the script that will start the Vagrant Windows machine, build and run the Windows docker container: `start.sh <build-tools-version> <python-version> <path-to-the-macos-bound-folder>`
`<build-tools-version>` must be either `16` or `17`, `<python-version>` must be one of `null`, `37`, `38` or `39`, and `<path-to-the-macos-bound-folder>` must be prepended with `C:`.
Example: `start.sh "16" "38" "C:/tmp/win-dev-home"`

The macOS bound folder, e.g. `/tmp/win-dev-home` in the example above, is bound in your Windows Docker machine to the `C:\Users\DevUser\Work` folder.

From there, you can either directly invoke `MSBuild` commands from the shell which has been started by the docker container, or you can connect by SSH to the Windows machine as user `DevUser` with password `Passw0rd`.
   * To connect in a new macos terminal, invoke the following shell command: `ssh -p 2222 DevUser@$(docker context inspect 2019-box | jq -r '.[0].Endpoints.docker.Host | .[6:] | .[:-5]')`
   * To use the Remote Explorer extension of Visual Studio Code (so you can edit and compile your Windows machine's code directly within your macos' Visual Studio Code editor), follow these steps:
      * You need first to get the IP address of your Windows machine by issuing the following shell command: `echo $(docker context inspect 2019-box | jq -r '.[0].Endpoints.docker.Host | .[6:] | .[:-5]')`.
      * Then, copy the resulting IP address and add the following entry in your `~/.ssh/config` file, after which your `buildtools2022` Windows machine will be accessible from the VSCode's Remote Explorer:

```
Host buildtools2022
  HostName <your-Windows-machine-IP>
  User DevUser
  Port 2222
```

Once you have finished with your Docker Windows BuildTools image, you can call the `stop.sh` script to stop the Docker image and the Vagrant Windows machine.
