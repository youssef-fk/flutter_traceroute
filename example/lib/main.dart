import 'package:flutter/material.dart';
import 'package:flutter_traceroute_example/src/ui/trace_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TraceScreen(),
    );
  }
}
