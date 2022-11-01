import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_traceroute/flutter_traceroute_method_channel.dart';

void main() {
  // MethodChannelFlutterTraceroute platform = MethodChannelFlutterTraceroute();
  const MethodChannel channel = MethodChannel('flutter_traceroute');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
