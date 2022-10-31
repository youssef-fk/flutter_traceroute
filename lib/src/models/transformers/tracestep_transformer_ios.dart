import 'package:flutter_traceroute/src/models/traceroute_enum.dart';
import 'package:flutter_traceroute/src/models/traceroute_step.dart';

abstract class TracestepTransformerIOS {
  static TracerouteStep? transform(Map<String, dynamic> data) {
    final typeJson = data['type'];
    final type = TracerouteEnum.values.singleWhere(
      (element) => TraceRouteEnumParser.parseEnum(element) == typeJson,
      orElse: () => TracerouteEnum.undefined,
    );

    switch (type) {
      case TracerouteEnum.start:
        return TracerouteStepStart(data['host'], data['ip'], data['ttl']);
      case TracerouteEnum.router:
        return TracerouteStepRouter(data['step'], data['ip'], data['duration']);
      case TracerouteEnum.routerDoesNotRespond:
        return TracerouteStepRouterDoesNotRespond(data['step']);
      case TracerouteEnum.finished:
        return TracerouteStepFinished(data['step'], data['ip'], data['latency']);
      case TracerouteEnum.failed:
        return TracerouteStepFailed(data['error']);
      case TracerouteEnum.undefined:
        return null;
    }
  }
}
