import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Mağaza görsellerini cihazdan alıp shots/raw altına yazar.
Future<void> main() => integrationDriver(
      onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? args]) async {
        final f = File('shots/raw/$name.png');
        f.createSync(recursive: true);
        f.writeAsBytesSync(bytes);
        return true;
      },
    );
