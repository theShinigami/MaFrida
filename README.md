# MaFrida

A simple yet powerful Magisk module that automates starting the [Frida](https://github.com/frida/frida) server on boot and provides a convenient command-line interface to manage different [Frida](https://github.com/frida/frida) versions on Android.


## Features

- Automatically starts frida-server at boot.
- Easily switch between different [Frida](https://github.com/frida/frida) versions.
- Lightweight CLI tool: `mafrida`, Built-in commands for downloading, starting, killing, and checking the status of frida-server.
- Enable/Disable `frida-server` on boot.

## Installation

1) Flash the module via Magisk Manager.
2) Reboot your device.
3) Use the mafrida command in a root shell.

## Usage

Use the `mafrida` CLI tool to manage the [Frida](https://github.com/frida/frida) server:

```sh
Usage: mafrida [--set <frida-version> | -g | kill | start | status | enable | disable]
    --set <version>   Set and install the specified Frida version (e.g., 16.6.1)
    -g                Show the currently set Frida version
    download          Download the frida-server binary for the set version
    kill              Force kill any running frida-server instance
    start             Start frida-server using the set version
    status            Check if frida-server is currently running
    enable            Enable frida-server to auto-start on boot
    disable           Disable frida-server from auto-starting on boot
```

### Demo
![mafrida-demo](https://github-production-user-asset-6210df.s3.amazonaws.com/56839725/437957303-5e68e968-c236-4c71-8005-a96b5da6ca1c.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20250427%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250427T145332Z&X-Amz-Expires=300&X-Amz-Signature=4968e79737d8b94f90728e671753bad51693fcd04ef852da3626ec11560725a7&X-Amz-SignedHeaders=host)


## Supported Platforms
- `arm`
- `arm64`
- `x86`
- `x86_64`


### Examples

#### Set Frida version:

```sh
mafrida --set 16.6.1
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

