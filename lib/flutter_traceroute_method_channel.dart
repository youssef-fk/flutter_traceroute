import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_traceroute/src/models/traceroute_step.dart';
import 'package:flutter_traceroute/src/models/transformers/tracestep_transformer.dart';
import 'package:flutter_traceroute/src/models/transformers/tracestep_transformer_android.dart';
import 'package:flutter_traceroute/src/models/transformers/tracestep_transformer_ios.dart';
import 'package:queue/queue.dart';

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

  late final TracestepTransformer tracestepTransformer;

  MethodChannelFlutterTraceroute() {
    if (Platform.isIOS) {
      tracestepTransformer = TracestepTransformerIOS();
    } else if (Platform.isAndroid) {
      tracestepTransformer = TracestepTransformerAndroid();
    }
  }

  @override
  Stream<TracerouteStep> trace(TracerouteArgs args) {
    final queue = Queue();

    final stream = traceEventChannel.receiveBroadcastStream();

    Future.delayed(Duration.zero).then((value) {
      methodChannel.invokeMethod<void>(traceMethodName, {
        'host': args.host,
        'ttl': args.ttl,
      });
    });

    return stream.transform<TracerouteStep>(
      StreamTransformer<dynamic, TracerouteStep>.fromHandlers(
        handleData: (data, sink) async {
          log(data);

          queue.add(() async {
            final step = await tracestepTransformer.transform(args.host, data);

            if (step != null) {
              sink.add(step);
            }
          });
        },
      ),
    );
  }

  @override
  Future<void> stopTrace() async {
    await methodChannel.invokeMethod(stopTraceMethodName);
  }
}
