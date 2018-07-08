# flutter_paper_trail

Send logs to Papertrail


# Usage


Setup:

```dart
import 'package:flutter_paper_trail/flutter_paper_trail.dart';

FlutterPaperTrail.initLogger(
        hostName: "secret.papertrailapp.com",
        programName: "flutter-test-app",
        port: 9999,
        machineName: "Simulator(iPhone8)");
    //for machine name use Flutter DeviceInfoPlugin

```

Calling:

```dart
FlutterPaperTrail.logError("My message");
```

Extra setup (when a user is logged in):

```dart
FlutterPaperTrail.setUserId("JohnDeer391");
```

