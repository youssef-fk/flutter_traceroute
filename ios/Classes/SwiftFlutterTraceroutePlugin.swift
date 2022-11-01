import Flutter
import UIKit
import SimpleTracer

public class SwiftFlutterTraceroutePlugin: NSObject, FlutterPlugin {
    
    private static var traceEventHandler: EventChannelHandler?
    private var  simpleTracer: SimpleTracer?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_traceroute", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterTraceroutePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        traceEventHandler = EventChannelHandler(
            id: "flutter_event_trace",
            messenger: registrar.messenger()
        )
    }
    
    public func handleTrace(host: String,  ttl: Int) {
        simpleTracer?.stop()
        simpleTracer = SimpleTracer.trace(host: host, maxTraceTTL: ttl) {  (result) in
            let data = TraceHelper.formatTraceStep(step: result)
            SwiftFlutterTraceroutePlugin.traceEventHandler?.send(event: data)
        }
    }
    
    public func stopTrace() {
        simpleTracer?.stop();
        simpleTracer = nil;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case "trace":
            let args = call.arguments as! Dictionary<String, Any>
            let host = args["host"] as! String
            let ttl = args["ttl"] as! Int
            
            handleTrace(host: host, ttl: ttl)
            break;
        case "stop_trace":
            stopTrace()
            break;
        default:
            result("iOS " + UIDevice.current.systemVersion)
            break;
        }
        
    }
}

private class TraceHelper {
    static func formatTraceStep(step: TraceStep) -> Dictionary<String, Any> {
        switch step {
        case .start(let host, let ip, let ttl):
            return  ["type": "start", "host": host, "ip": ip, "ttl": ttl]
        case .router(let step, let ip, let duration):
            return  ["type": "router", "step": step, "ip": ip, "duration": duration]
        case .routerDoesNotRespond(let step):
            return ["type": "routerDoesNotRespond","step": step]
        case .finished(let step, let ip, let latency):
            return  ["type": "finished","step": step, "ip": ip, "latency": latency]
        case .failed(let error):
            return ["type": "failed","error": error]
        }
    }
}
