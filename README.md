# Reverse Shell Service

![](https://img.shields.io/github/v/release/cadnza/reverseShellService)

Keeps a reverse shell on your Linux box open on your jump server. 🌌 Awfully handy for remote administration (as long as you have proper access control). 💂‍♀️

## How does it work?

Thing runs through [`systemd`](https://systemd.io/) to start a system service when your box turns on that opens an SSH tunnel to your jump server. Basically exposes your computer to the world. Use with care and caution. ☢️

## Instructions

Run `setup.sh`. Then connect to your box through the jump server using the user, port, and address you've specified.

**Note**: _Made in VSCode on the Raspberry Pi back at home from what may as well have been the other side of the world thanks to the rock stars that came up with [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview). #TheFutureIsNow_
