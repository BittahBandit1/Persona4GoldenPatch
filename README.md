# Persona 4 Golden Executible Patcher
A small, unofficial Swift app for the Windows Steam edition of Persona 4 Golden (build 10836033) on Apple silicon. It replaces a self-modifying CPU identification routine with a static equivalent. Functionality was confirmed with Crossover 26.3. This does not fix the crash that occurs with Crossover Preview ARM.

## Build and use
1. On a Mac with the Xcode command line tools, run `sh build.sh` in this folder. Open `build/P4G Patcher.app`.
2. Select your original P4G.exe and choose a new output filename. The app checks both SHA-256 hashes and refuses to overwrite existing files.
3. Quit the game. Rename the installed original to P4G-original.exe as a backup, then put the generated copy beside it under the name P4G.exe. Launch through Steam as usual.
4. To undo, move the patched file out and restore the original filename. Reapplying after a Steam update requires a supported original hash.

This patch only addresses the CPU compatibility issue. The repository contains no game executable. The build script signs locally with an ad hoc signature. This application will not, and is not designed for, circumventing Digital Rights Management, nor will this application work with pirated versions of Persona 4 Golden.

## Note
This application has not been verified with GameHub, Sikarugir, or Whiskey.
