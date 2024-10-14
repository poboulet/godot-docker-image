# Docker Image for Godot Engine (with Mono Support)

This repository provides a Docker image for the Godot Engine with Mono support. It includes everything necessary to install Godot, the C# SDK, and run the engine in non-headless mode, allowing you to execute tests using gdUnit4. 

## Usage

### Docker CLI

#### Step 1: Pull the Latest Image

To pull the most recent version of the Docker image from GitHub Container Registry:

```
docker pull ghcr.io/poboulet/godot-dev-mono:latest
```

#### Step 2: Run the Container

To run the container, execute the following command:

```bash
docker run <options> ghcr.io/poboulet/godot-dev-mono:latest
```

Replace <options> with any additional flags or volume mappings you need (e.g., -it to run interactively, -v to mount directories, -p to map ports).

##### Example: Running with Volume Mounting

To mount a local project directory inside the container:

```bash
docker run -it --rm -v /path/to/your/project:/workspace ghcr.io/poboulet/godot-dev-mono:latest
```

This mounts your local project directory to /workspace inside the container.

### GitHub Workflow

```yaml
jobs:
    job-name:
        runs-on: ubuntu-latest
        container:
            image: ghcr.io/poboulet/godot-dev-mono:latest
```

## Building the Docker Image

To build the image yourself, run the following command:

```dockerfile
docker build -t godot-dev -f ./Dockerfile.godot-dev --build-arg MONO=true --build-arg GODOT_VERSION=4.3 .
```

### Arguments
- ```MONO```: Set this to `true` to include the Mono version of Godot. The default value is `false`.
- ```GODOT_VERSION```: Specify the version of Godot to be used. The default is version `4.3`.

### Running the Custom-Built Image

Once the image is built, you can run it using the following command:

```bash
docker run <options> godot-dev
```

Replace <options> with any necessary Docker flags or options as described above.