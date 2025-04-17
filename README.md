# MaFrida

A simple yet powerful Magisk module that automates starting the [Frida](https://github.com/frida/frida) server on boot and provides a convenient command-line interface to manage different [Frida](https://github.com/frida/frida) versions on Android.


## Features

- Automatically starts frida-server at boot.
- Easily switch between different [Frida](https://github.com/frida/frida) versions.
- Lightweight CLI tool: `mafrida`, Built-in commands for downloading, starting, killing, and checking the status of frida-server.

## Installation

1) Flash the module via Magisk Manager.
2) Reboot your device.
3) Use the mafrida command in a root shell.

## Usage

Use the `mafrida` CLI tool to manage the [Frida](https://github.com/frida/frida) server:

```sh
Usage: mafrida [--set <frida-version> | -g | download | kill | start | status]

  --set <version>   Set and install the specified Frida version (e.g., 16.1.4)
  -g                Show the currently set Frida version
  download          Download the frida-server binary for the set version
  kill              Force kill any running frida-server instance
  start             Start frida-server using the set version
  status            Check if frida-server is currently running
```

### Examples

#### Set Frida version:

```sh
mafrida --set 16.1.4
```

#### Download the binary for the current version:

```sh
mafrida download
```

#### Start the server:

```sh
mafrida start
```

#### Check server status:

```
mafrida status
```

#### Kill the running instance:

```
mafrida kill
````

## Requirements

1) Magisk installed
2) Root access

