import 'package:flutter_traceroute/flutter_traceroute.dart';
import 'dart:io' as io;

abstract class TracestepTransformer<T> {
  static Future<String> reverseLookup(String ip) async {
    final address = io.InternetAddress.tryParse(ip);

    if (address == null) return ip;

    try {
      final reversed = await address.reverse();

      return '$ip (${reversed.host})';
    } catch (e) {
      return ip;
    }
  }

  Future<TracerouteStep?> transform(String targetHost, T data);
}
