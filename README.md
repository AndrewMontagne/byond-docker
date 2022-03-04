# BYOND Docker Container

This is a docker container for BYOND development and runtime. BYOND binaries are already available on the path by default.

This image is built automatically on a schedule and kept up to date with the latest minor revisions.

## Libraries

The following BYOND libraries are provided under `/root/.byond/bin/`:
- [tgstation/rust-g](https://github.com/tgstation/rust-g) as `rust_g.so`
- [willox/auxtools](https://github.com/willox/auxtools) debug server as `libdebugserver.so`

The following tools are provided:
- [SpaceManiac/SpacemanDMM](https://github.com/SpaceManiac/SpacemanDMM)

DM code to hook into these libraries are provided under `/byond/lib/` to allow them to be built and compiled into your project at runtime without contaminating the licence of your codebase.

## Windows Subsystem for Linux Support

This container also automatically addresses a bug when running under Windows Subsystem for Linux. Many thanks to [Ninji](https://twitter.com/_Ninji) for their assistance on this.

A writeup of this is available [here](https://montagne.uk/byond-docker/).
