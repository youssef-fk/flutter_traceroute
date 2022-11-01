# Example

Demonstrates how to use the flutter_traceroute plugin.

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_traceroute/flutter_traceroute.dart';
import 'package:flutter_traceroute/flutter_traceroute_platform_interface.dart';

class TraceScreen extends StatefulWidget {
  static const defaultDNS = '8.8.8.8';

  const TraceScreen({super.key});

  @override
  State<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends State<TraceScreen> {
  List<TracerouteStep> traceResults = [];

  late final FlutterTraceroute traceroute;
  late final TextEditingController hostController;
  late final TextEditingController ttlController;

  @override
  void initState() {
    super.initState();

    traceroute = FlutterTraceroute();
    hostController = TextEditingController()..text = TraceScreen.defaultDNS;
    ttlController = TextEditingController();
  }

  void onTrace() {
    setState(() {
      traceResults = <TracerouteStep>[];
    });

    final host = hostController.text;
    final ttl = int.tryParse(ttlController.text) ?? TracerouteArgs.ttlDefault;

    final args = TracerouteArgs(host: host, ttl: ttl);

    traceroute.trace(args).listen((event) {
      setState(() {
        traceResults = List<TracerouteStep>.from(traceResults)..add(event);
      });
    });
  }

  void onStop() {
    traceroute.stopTrace();

    setState(() {
      traceResults = <TracerouteStep>[];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traceroute')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Input IP address'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'IP address',
                labelText: 'IP',
              ),
              controller: hostController,
            ),
            if (Platform.isIOS) const SizedBox(height: 16),
            if (Platform.isIOS)
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Time to live - iOS Only',
                  labelText: 'TTL - iOS Only',
                ),
                keyboardType: TextInputType.number,
                controller: ttlController,
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: onTrace,
                  child: const Text('Trace'),
                ),
                OutlinedButton(
                  onPressed: onStop,
                  child: const Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final result in traceResults)
                  Text(
                    result.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: result is TracerouteStepFinished ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```
