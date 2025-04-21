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
function script_usage() {
    printf "Usage: mafrida [--set <frida-version> | -g | kill | start | status]\n"
    printf "  --set <version>   Set and install the specified Frida version (e.g., 16.1.4)\n"
    printf "  -g                Show the currently set Frida version\n"
    printf "  download          Download the frida-server binary for the set version\n"
    printf "  kill              Force kill any running frida-server instance\n"
    printf "  start             Start frida-server using the set version\n"
    printf "  status            Check if frida-server is currently running\n"
    printf "  enable            Enable frida-server to auto-start on boot\n"
    printf "  disable           Disable frida-server from auto-starting on boot\n"
}
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

```sh
mafrida status
```

#### Kill the running instance:

```sh
mafrida kill
````

#### Enable frida server on boot
```sh
mafrida enable
```

#### Disable frida server on boot
```sh
mafrida disable
```

## Requirements

1) Magisk installed
2) Root access

