package com.traceroute.flutter_traceroute

import android.os.Handler
import io.flutter.plugin.common.EventChannel

class TracerouteStreamHandler : EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null

    fun sendNewTrace(trace: String) {
        sink?.success(trace)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}