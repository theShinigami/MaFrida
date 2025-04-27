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

![mafrida-demo](https://private-user-images.githubusercontent.com/56839725/437954863-3d85d667-5727-4bda-974f-2dad72f33c78.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDU3NTkxNjQsIm5iZiI6MTc0NTc1ODg2NCwicGF0aCI6Ii81NjgzOTcyNS80Mzc5NTQ4NjMtM2Q4NWQ2NjctNTcyNy00YmRhLTk3NGYtMmRhZDcyZjMzYzc4LmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA0MjclMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNDI3VDEzMDEwNFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWU4YTVmM2Q5MDY3MzI5Yjk2Y2JjYzM4ZmQzYzY1YmJjYjk4NTUzZGUwZDg5YjVlZjAzMGM5OTFiZDJhNjIyYTcmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.UEI7CmwW3wl3gnJMQKtWImy5Kw6o4ygMOQwvs_-gxYs)


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

