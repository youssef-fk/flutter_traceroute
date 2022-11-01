import 'package:flutter_traceroute/src/models/traceroute_step.dart';

import 'flutter_traceroute_platform_interface.dart';
export 'src/models/traceroute_step.dart';

class FlutterTraceroute {
  Stream<TracerouteStep> trace(TracerouteArgs args) {
    return FlutterTraceroutePlatform.instance.trace(args);
  }

  Future<void> stopTrace() {
    return FlutterTraceroutePlatform.instance.stopTrace();
  }
}
