# Steam Linux SDK Rust (bevy) Builder

This is a helper image to create native Linux builds targeting the Steam Soldier (v3) SDK.

## Building the image

Current recommended procedure is to tag according to the `rustc` version that is built into the image.

Example:

```
podman build --rm -t steam-builder:v1.89 .
podman tag steam-builder:v1.89 steam-builder:latest
podman tag steam-builder:v1.89 steam-builder:stable
```

## Compiling a project

At this time the project workspace needs to be volume mounted in the image's /src directory, and on a
successful build the compiled binary will be copied to the image's /output directory (which should 
also be mounted in order to keep the executable).

Example:

```
podman run -v $HOME/src/my_rust_project:/src -v $HOME/release:/output -it steam-builder:v1.89
```

The image will accept any one of the following commands:

```
release		    Run a release build, equivalent to 'cargo build --release'
debug		    Run a debug build, equivalent to 'cargo build'
clean		    Clean build artifacts (only useful if using persistent builds)
-h, --help	    Print this help message
-V, --version	Output the Rust compiler version (rustc --version)
```

The default command is `release`.
