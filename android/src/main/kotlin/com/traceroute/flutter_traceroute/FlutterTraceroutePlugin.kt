package com.traceroute.flutter_traceroute

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.qiniu.android.netdiag.Task
import com.qiniu.android.netdiag.TraceRoute
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


//import com.wandroid.traceroute.TraceRoute
//import com.synaptictools.traceroute.TraceRoute



/** FlutterTraceroutePlugin */
class FlutterTraceroutePlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler  {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity

    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())

    private lateinit var channel: MethodChannel
    private var messageChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

    private var task: Task? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_traceroute")
        channel.setMethodCallHandler(this)

        messageChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_event_trace")
        messageChannel?.setStreamHandler(this)
    }

    private fun onTrace(host: String) {
        task?.stop()
        task = TraceRoute.start(host, { result ->
            uiThreadHandler.post {
                eventSink?.success(result)
            }
        }, { _ -> })
    }

    private fun onStop() {
        task?.stop()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "trace" -> {
                val args = call.arguments as Map<String, Any>
                val host = args["host"] as String

                onTrace(host)
            }
            "stop_trace" -> onStop()
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
//        tracerouteStreamHandler.onCancel(null)
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        messageChannel = null
    }
}
