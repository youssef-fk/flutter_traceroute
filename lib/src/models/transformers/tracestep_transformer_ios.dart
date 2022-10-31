import 'package:flutter_traceroute/src/models/traceroute_enum.dart';
import 'package:flutter_traceroute/src/models/traceroute_step.dart';
import 'package:flutter_traceroute/src/models/transformers/tracestep_transformer.dart';

class TracestepTransformerIOS implements TracestepTransformer<Map<String, dynamic>> {
  @override
  Future<TracerouteStep?> transform(String targetHost, Map<String, dynamic> data) async {
    final typeJson = data['type'];
    final type = TracerouteEnum.values.singleWhere(
      (element) => TraceRouteEnumParser.parseEnum(element) == typeJson,
      orElse: () => TracerouteEnum.undefined,
    );

    switch (type) {
      case TracerouteEnum.start:
        final ip = await TracestepTransformer.reverseLookup(data['ip']);
        return TracerouteStepStart(data['host'], ip, data['ttl'], null);
      case TracerouteEnum.router:
        final ip = await TracestepTransformer.reverseLookup(data['ip']);
        return TracerouteStepRouter(data['step'], ip, data['duration']);
      case TracerouteEnum.routerDoesNotRespond:
        return TracerouteStepRouterDoesNotRespond(data['step']);
      case TracerouteEnum.finished:
        final ip = await TracestepTransformer.reverseLookup(data['ip']);
        return TracerouteStepFinished(data['step'], ip, data['latency']);
      case TracerouteEnum.failed:
        return TracerouteStepFailed(data['error']);
      case TracerouteEnum.undefined:
        return null;
    }
  }
}
