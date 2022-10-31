import 'package:flutter/material.dart';
import 'package:flutter_traceroute/flutter_traceroute.dart';
import 'package:flutter_traceroute/flutter_traceroute_platform_interface.dart';

class TraceScreen extends StatefulWidget {
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
    hostController = TextEditingController()..text = '10.11.109.1';
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
      appBar: AppBar(title: Text('Traceroute')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Input IP address'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'IP address',
                labelText: 'IP',
              ),
              controller: hostController,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Time to live',
                labelText: 'TTL',
              ),
              controller: ttlController,
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            SizedBox(height: 16),
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
