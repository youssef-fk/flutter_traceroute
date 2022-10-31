package com.traceroute.flutter_traceroute

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterTraceroutePlugin */
class FlutterTraceroutePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var tracerouteStreamHandler: TracerouteStreamHandler

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_traceroute")
        channel.setMethodCallHandler(this)

        tracerouteStreamHandler = TracerouteStreamHandler()

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_event_trace")
        eventChannel.setStreamHandler(tracerouteStreamHandler)
    }

    private fun onTrace(host: String, ttl: Int) {
//    val result = TraceRoute.

    }

    private fun onStop() {

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "trace" -> {
                val args = call.arguments as Map<*, *>
                val host = args["host"] as String
                val ttl = args["ttl"] as Int

                onTrace(host, ttl)
            }
            "stop_trace" -> onStop()
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        tracerouteStreamHandler.onCancel(null)
    }
}
