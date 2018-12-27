# My console environment

## Synopsis
This is the theme and modules that I use for my every day task that involves windows powershell.

## Preview

![demo](https://raw.githubusercontent.com/bibistroc/ConEmu-environment/master/assets/demo.gif)

## Prerequisites
1. [ConEmu](https://conemu.github.io/)
2. [git](https://git-scm.com/downloads)

You can use the links to download & install them or you can use a `choco` package manager to install them (using an elevated powershell):

1. [if you don't have it] install [chocolatey](https://chocolatey.org/install)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```
2. install [git](https://git-scm.com/downloads)
```powershell
choco install git.install --params "/GitAndUnixToolsOnPath /NoAutoCrlf"
```
3. install [ConEmu](https://conemu.github.io/)
```powershell
choco install conemu
```

## Install theme & modules
You can inspect the code that is executed here: [https://r.gbarbu.eu/ps](https://r.gbarbu.eu/ps). To install what is needed, run the following command into powershell

```powershell
iex (new-object net.webclient).downloadstring('https://r.gbarbu.eu/ps')
```

## ConEmu additional configuration
In order to view the special characters in console, you need to download the following font: [Meslo LG M Regular](https://github.com/powerline/fonts/blob/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf) ([Mirror](https://github.com/bibistroc/ConEmu-environment/blob/master/assets/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf)).
After installing the font on local system, you must select the fond inside ConEmu.

