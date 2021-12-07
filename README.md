# What is this?

This is a script to install Google's Endpoint Verification in Fedora 35.

The 'google-chrome-stable' package on Fedora's Repository does not support the Endpoint Verification, and Google only provide support for Debian based distros  (endpoint-verification.deb).

So, this script will help you do the following:

1. Download the official .deb file from Google.
2. Extract the debian files.
3. Copy to each directories for Google Chrome to use it. (sudo needed)

# Todo:

- [ ] Implement GPG verification of files for security.
- [ ] Uninstallation script.

# Credits:

- The code is edited from [leafi/endpoint-verification-any-linux](https://github.com/leafi/endpoint-verification-any-linux)
