import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_traceroute/flutter_traceroute.dart';
import 'package:flutter_traceroute/flutter_traceroute_platform_interface.dart';
import 'package:flutter_traceroute/flutter_traceroute_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTraceroutePlatform with MockPlatformInterfaceMixin implements FlutterTraceroutePlatform {
  @override
  Future<void> stopTrace() async {}

  @override
  Stream<TracerouteStep> trace(TracerouteArgs args) {
    return StreamController<TracerouteStep>().stream.asBroadcastStream();
  }

  // @override
  // Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterTraceroutePlatform initialPlatform = FlutterTraceroutePlatform.instance;

  test('$MethodChannelFlutterTraceroute is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTraceroute>());
  });

  test('getPlatformVersion', () async {
    // FlutterTraceroute flutterTraceroutePlugin = FlutterTraceroute();
    MockFlutterTraceroutePlatform fakePlatform = MockFlutterTraceroutePlatform();
    FlutterTraceroutePlatform.instance = fakePlatform;

    // expect(await flutterTraceroutePlugin.getPlatformVersion(), '42');
  });
}
