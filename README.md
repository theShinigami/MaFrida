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
![mafrida-demo](https://private-user-images.githubusercontent.com/56839725/437957303-5e68e968-c236-4c71-8005-a96b5da6ca1c.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDU3NTk4MzEsIm5iZiI6MTc0NTc1OTUzMSwicGF0aCI6Ii81NjgzOTcyNS80Mzc5NTczMDMtNWU2OGU5NjgtYzIzNi00YzcxLTgwMDUtYTk2YjVkYTZjYTFjLmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA0MjclMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNDI3VDEzMTIxMVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTEyYmU4NWU3NWMwNmQ3MmE5NGZkODQwY2I5YTk1OWRkNDJhMTQ2OTgwZTNkMmM4ZWM3Nzc5N2E0MmJkNDY4NTImWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.eBvxkwYHa1o0bpiq2JjUQdiP7MUyh9Ej3oAk7-a16r4)


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

