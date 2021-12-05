# What is this?

This is a script to install Google's Endpoint Verification in Fedora 35.

The 'google-chrome-stable' package on Fedora's Repository does not support the Endpoint Verification, and Google only provide support for Debian (endpoint-verification.deb).

This script will do the following:

1. Download the official .deb file from Google.
2. Extract the debian files.
3. Copy to each directories for Google Chrome to use it. (sudo needed)

# Todo:

- [ ] Implement GPG verification of files for security.
- [ ] Uninstallation script.
