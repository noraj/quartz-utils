# Install

## Manual

For `x86_64-linux-gnu`, a pre-compiled static binary is available and for pre-compiled object, see [releases](https://github.com/noraj/quartz-utils/releases). Else you can [build](build.md) one.

Put the binaries somewhere under your PATH.

## ArchLinux

AUR: [quartz-utils](https://aur.archlinux.org/packages/quartz-utils), [quartz-utils-git](https://aur.archlinux.org/packages/quartz-utils-git), [quartz-utils-bin](https://aur.archlinux.org/packages/quartz-utils-bin)

Manually:

```shell
git clone https://aur.archlinux.org/quartz-utils.git
cd quartz-utils
makepkg -sic
```

With an AUR helper ([Pacman wrappers](https://wiki.archlinux.org/index.php/AUR_helpers#Pacman_wrappers)), e.g. pikaur:

```shell
pikaur -S quartz-utils
```

## Packages

[![Packaging status](https://repology.org/badge/vertical-allrepos/quartz-utils.svg)](https://repology.org/project/quartz-utils/versions)
