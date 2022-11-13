# PALAEMON Passenger App

Part of the [PALAEMON](https://palaemonproject.eu/) EU Project, developed in cooperation with the University of Aegean (UAEG).

## Features:

- Provides passengers with a way to message the crew should an emergency happen (they get injured, they'd wish to report something etc...)
- Provides a way for the crew to message the passengers during an emergency and/or evacuation.
- Features 2-way voice and text communication using the [Mumble](https://www.mumble.info/) protocol.
- Features integration with the [Situm](https://situm.com/en/) framework, to provide positioning and wayfinding capabilities inside ships.

## How to build:

- Get an API key by signing up to [Situm](https://situm.com/en/).
- Create an instance of `Config` to match your Mumble server and Situm connection parameters. You can ignore the `Register` procedure, as this is only for the production version. The production config will not be pushed until the official release of the app.
- Clone the [flutter_wayfinding](https://github.com/situmtech/flutter-wayfinding) provided by Situm, in a directory of your choosing.
- Modify this part within `pubspec.yaml` to point to the cloned plugin:
```yaml
dependencies:
  # ...
  situm_flutter_wayfinding:
    path: "../flutter-wayfinding"  # Change this to point to the cloned plugin. In my case, its in the previous directory.
```
- `flutter pub get`
- Ensure you have a working NDK (meaning no spaces in your SDK and Pub Cache paths).
- Optional: If you'd wish to disable the Situm SDK, you can leave the `situmEmail` and `situmPassword` to their default values (`""`). This disables Situm automatically.
- `flutter run ...`

## Contributing:

- If you'd wish to contribute to the project, please pick from the open issues. **Other additions will not be accepted**.