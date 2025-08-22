# Rust (bevy) Builder for the Steam Linux SDK (sniper)

This is a helper image to create native Linux builds targeting the Steam "sniper" (v3) Linux runtime
using Steam's Linux SDK v3.

The current use case is to volume mount your Rust project to the image's /src directory and allow the
build script to compile the project directly. It's recommended to run `cargo clean` prior to compiling,
particularly when to creating production/release candidate builds.

This image is intended to be used with podman's rootless environment; using Docker or podman rootful
may result in unexpected permissions set in the build directory when re-using build artifacts (eg,
when volume mounting the full Rust workspace) and is not recommended.

## Building the image locally

Current recommended procedure is to tag according to the `rustc` version that is built into the image.

Default behaviour is to pull the latest stable rustc version.

Example:

```
podman build --rm -t steam-builder:v1.89 .
podman tag steam-builder:v1.89 steam-builder:latest
podman tag steam-builder:v1.89 steam-builder:stable
```

## Compiling a Rust project using this image

**Running podman/docker as `root` (sudo) is _not_ recommended.**

The image will accept the following commands:

```
release		    Run a release build, equivalent to 'cargo build --release'
debug		    Run a debug build, equivalent to 'cargo build'
--clean		    A reproducible build with no persistence
-h, --help	    Print this help message
-V, --version	Output the Rust compiler version (rustc --version)
```

The default command is `release`.

### With persistent, reusable build artifacts

At this time the project workspace needs to be volume mounted in the image's /src directory, and on a
successful build the compiled binary will be copied to the image's /output directory (optional since
in this scenario cargo will build the project in the workspace as defined in your cargo configuration)

Example:

```
podman run -v $HOME/src/my_rust_project:/src:z -it steam-builder:v1.89
```

or

```
podman run -v $HOME/src/my_rust_project:/src:z -it steam-builder:v1.89 debug
```

### Without persistence for reproducible builds

Use this invocation for reproducible builds or to leave your local workspace build artifacts untouched.
This functions by changing the cargo build target directory to an internal directory that has no
persistence.

```
podman run -v $HOME/src/my_rust_project:/src:z -v $HOME/release:/output:z -it steam-builder:v1.89 release --clean
```

