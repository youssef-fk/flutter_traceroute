import 'dart:developer';

import 'package:flutter_traceroute/src/models/traceroute_step.dart';
import 'package:flutter_traceroute/src/models/transformers/tracestep_transformer.dart';

class TracestepTransformerAndroid implements TracestepTransformer<String> {
  final _numbersRegex = RegExp(r'[^0-9]');
  int getNumbersOnly(String text) => int.parse(text.replaceAll(_numbersRegex, ''));

  @override
  Future<TracerouteStep?> transform(String targetHost, String data) async {
    try {
      final split = data.split('\t').map((e) => e.trim()).toList()..removeWhere((element) => element.isEmpty);

      final step = getNumbersOnly(split.elementAt(0));
      final ip = await TracestepTransformer.reverseLookup(split.elementAt(1));

      if (ip == '*') {
        return TracerouteStepRouterDoesNotRespond(step);
      }

      final duration = getNumbersOnly(split.elementAt(2));

      if (step == 1) {
        return TracerouteStepStart(targetHost, ip, null, duration, true);
      }

      if (ip == targetHost) {
        return TracerouteStepFinished(step, ip, duration);
      }

      return TracerouteStepRouter(step, ip, duration);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
