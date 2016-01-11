# Using the iOS Development Environment

This document contains information on how to use the iOS Development Environment to build Dolphin.

## Prerequisites

* A Mac running OS X 10.10+ (a virtual machine should work, but I have not tested it)
* An iOS device with a 64-bit processor
* Xcode 7.1.1+

The following need to be installed using [Homebrew](http://brew.sh/):

* cmake
* dpkg

Once all of the prerequisites have been met, you can browse to `Source/iOS/Application` and open the `DolphiniOS.xcodeproj` project file.

## Schemes

Each scheme allows you to build Dolphin for iOS in different ways.

*  "DolphiniOS"

This scheme builds the application. You can use this scheme to run the application in the iOS Simulator, install it to a non-jailbroken device, or just build a binary and .deb package of the emulator.

*  "Install to Jailbroken Device"

This scheme builds the application, copies it to a jailbroken device, and installs it. To use this scheme, you need to go through a few setup steps first (see below). The difference between running Dolphin on a physical device with the main "DolphiniOS" target and this target is that the "DolphiniOS" target installs the application into the normal sandbox environment. With this special target, we can install it directly to ```/Applications/``` (all applications stored there have no sandbox restrictions).

To run this target, select the destination as "Generic iOS Device" and go to Product -> Build (alternatively, press Command + B).

## Setting up the "Install to Jailbroken Device" scheme

1. Install OpenSSH on your iOS device using Cydia.

2. SSH into your device and change your "root" and "mobile" passwords (the default password is "alpine").

3. If you already have an SSH key, skip to step 5. Otherwise, continue on to step 4.

4. On your Mac, generate an SSH key by running ```ssh-keygen -t rsa```. Press ENTER when asked for a location to use the default. It is highly recommended that you set a passphrase to protect your SSH key, however, this is not required.

5. Store the SSH key into your Keychain by typing in the following command: ```ssh-add -K ~/.ssh/id_rsa```

6. SSH to your device as root and make a folder called ```.ssh``` in your home directory.

7. On your Mac, copy your public key to your device: ```scp ~/.ssh/id_rsa.pub root@[your device's IP address]:~/.ssh/```

8. On your iOS device, run this command: ```cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys```

9. Disconnect from your device and connect again. If you have done this correctly, you should not be prompted for a password when reconnecting.

10. In ```Source/iOS/Application```, create a file named ```device_ip``` containing a single line with your device's IP address.

Once you have followed all of the steps, the scheme should function properly!
