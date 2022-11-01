import 'package:equatable/equatable.dart';

typedef OnTracerouteStep = void Function(TracerouteStep step);

/// Base class
abstract class TracerouteStep extends Equatable {
  @override
  bool get stringify => true;
}

class TracerouteStepStart extends TracerouteStep {
  TracerouteStepStart(this.host, this.ip, this.ttl, this._duration, [this._isAndroid = false])
      : assert(_isAndroid == true && _duration != null);

  final String host;
  final String ip;
  final int? _duration;
  final int? ttl;
  final bool _isAndroid;

  @override
  List<Object?> get props => [host, ip, ttl];

  @override
  String toString() {
    var str = 'Starting traceroute for $host';

    if (_isAndroid) {
      str += '\n${TracerouteStepRouter(1, ip, _duration!)}';
    }

    return str;
  }
}

class TracerouteStepRouter extends TracerouteStep {
  TracerouteStepRouter(this.step, this.ip, this.duration);

  final int step;
  final String ip;
  final int duration;

  @override
  List<Object?> get props => [step, ip, duration];

  @override
  String toString() {
    return '#$step    $ip  ${duration}ms';
  }
}

class TracerouteStepRouterDoesNotRespond extends TracerouteStep {
  TracerouteStepRouterDoesNotRespond(this.step);

  final int step;

  @override
  List<Object?> get props => [step];

  @override
  String toString() {
    return '...';
  }
}

class TracerouteStepFinished extends TracerouteStep {
  TracerouteStepFinished(this.step, this.ip, this.latency);

  final int step;
  final String ip;
  final int latency;

  @override
  List<Object?> get props => [step, ip, latency];

  @override
  String toString() {
    return '#$step    $ip  ${latency}ms' '\n Destination reached';
  }
}

class TracerouteStepFailed extends TracerouteStep {
  TracerouteStepFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() {
    return 'FAIL traceroute. $error';
  }
}
