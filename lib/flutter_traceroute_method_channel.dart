import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_traceroute/src/models/traceroute_step.dart';
import 'package:flutter_traceroute/src/models/transformers/tracestep_transformer_ios.dart';

import 'flutter_traceroute_platform_interface.dart';

/// An implementation of [FlutterTraceroutePlatform] that uses method channels.
class MethodChannelFlutterTraceroute extends FlutterTraceroutePlatform {
  // Channels
  static const methodChannelName = 'flutter_traceroute';
  static const traceEventChannelName = 'flutter_event_trace';

  // Method names
  static const traceMethodName = 'trace';
  static const stopTraceMethodName = 'stop_trace';

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(methodChannelName);

  @visibleForTesting
  final traceEventChannel = const EventChannel(traceEventChannelName);

  @override
  Stream<TracerouteStep> trace(TracerouteArgs args) {
    final stream = traceEventChannel.receiveBroadcastStream();

    Future.delayed(Duration.zero).then((value) {
      methodChannel.invokeMethod<void>(traceMethodName, {
        'host': args.host,
        'ttl': args.ttl,
      });
    });

    return stream.transform<TracerouteStep>(
      StreamTransformer<dynamic, TracerouteStep>.fromHandlers(
        handleData: (data, sink) {
          TracerouteStep? step;
          if (Platform.isIOS) {
            step = TracestepTransformerIOS.transform(Map<String, dynamic>.from(data));
          }

          if (step != null) {
            sink.add(step);
          }
        },
      ),
    );
  }

  @override
  Future<void> stopTrace() async {
    await methodChannel.invokeMethod(stopTraceMethodName);
  }
}
