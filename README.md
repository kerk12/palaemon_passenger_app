# PALAEMON Passenger App

Part of the [PALAEMON](https://palaemonproject.eu/) EU Project, developed in cooperation with the University of Aegean (UAEG).

## Features:

- Provides passengers with a way to message the crew should an emergency happen (they get injured, they'd wish to report something etc...)
- Provides a way for the crew to message the passengers during an emergency and/or evacuation.
- Features 2-way voice and text communication using the [Mumble](https://www.mumble.info/) protocol.

## How to build:

- Create an instance of `Config` to match your Mumble server connection parameters. You can ignore the `Register` procedure, as this is only for the production version. The production config will not be pushed until the official release of the app.
- `flutter pub get`
- Ensure you have a working NDK (meaning no spaces in your SDK and Pub Cache paths).
- `flutter run ...`
