// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:js' as js;

import 'package:flutter_traceroute/src/models/traceroute_step.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_traceroute_platform_interface.dart';

/// A web implementation of the FlutterTraceroutePlatform of the FlutterTraceroute plugin.
class FlutterTracerouteWeb extends FlutterTraceroutePlatform {
  /// Constructs a FlutterTracerouteWeb
  FlutterTracerouteWeb();

  static void registerWith(Registrar registrar) {
    FlutterTraceroutePlatform.instance = FlutterTracerouteWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  Stream<TracerouteStep> trace(TracerouteArgs args) {
    // TODO: implement trace
    throw UnimplementedError();
  }

  @override
  Future<void> stopTrace() {
    // TODO: implement stopTrace
    throw UnimplementedError();
  }
}
