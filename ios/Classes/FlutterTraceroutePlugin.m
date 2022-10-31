#import "FlutterTraceroutePlugin.h"
#if __has_include(<flutter_traceroute/flutter_traceroute-Swift.h>)
#import <flutter_traceroute/flutter_traceroute-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_traceroute-Swift.h"

#endif

@implementation FlutterTraceroutePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterTraceroutePlugin registerWithRegistrar:registrar];
}
@end
