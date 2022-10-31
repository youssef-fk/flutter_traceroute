import 'package:equatable/equatable.dart';
import 'package:flutter_traceroute/src/models/traceroute_step.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_traceroute_method_channel.dart';

abstract class FlutterTraceroutePlatform extends PlatformInterface {
  /// Constructs a FlutterTraceroutePlatform.
  FlutterTraceroutePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTraceroutePlatform _instance = MethodChannelFlutterTraceroute();

  /// The default instance of [FlutterTraceroutePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTraceroute].
  static FlutterTraceroutePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTraceroutePlatform] when
  /// they register themselves.
  static set instance(FlutterTraceroutePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<TracerouteStep> trace(TracerouteArgs args);
  Future<void> stopTrace();
}

class TracerouteArgs extends Equatable {
  static const ttlDefault = 10;

  final String host;
  final int ttl;

  const TracerouteArgs({
    required this.host,
    this.ttl = ttlDefault,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}
