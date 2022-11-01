# Flutter Traceroute

A minimalist Flutter plugin for performing **TRACEROUTE**
Currently supported on *Android* and *IOS*

## Limitations

- TTL is not supported on Android
- IOS takes a little more time between steps, not sure what the root cause is

## Installation

### IOS

At the beginning of your **Podfile**, set the ios platform version to `14`

```ruby
platform :ios, '14.0'
```

At the end of your **Podfile**, add the following pods

```ruby
pod 'SimplePing', :git => 'https://github.com/youssef-fk/SimplePing.git'
pod 'SimpleTracer', :git => 'https://github.com/youssef-fk/SimpleTracer.git'
```

### Android

All set

## Usage

```dart
const args = TracerouteArgs(
  host: '8.8.8.8',
  ttl: 20, // IOS ONLY
);
final stream = FlutterTraceroute().trace(args);
stream.listen((event) {
  if (event is TracerouteStepStart) {} // ...
  if (event is TracerouteStepRouter) {} // ...
  if (event is TracerouteStepRouterDoesNotRespond) {} // ...
  if (event is TracerouteStepFinished) {} // ...
  if (event is TracerouteStepFailed) {} // ...
});
```

### Objects definitions

| Class | Attributes | Description |
|-------|------------|------------ |
|TracerouteStep |-|Base class
|TracerouteStepStart |String **host**, String **ip**, int **ttl**|Base class
|TracerouteStepRouter |int **step**, String **ip**, int **duration**|Router jump
|TracerouteStepRouterDoesNotRespond |int **step**|Jump timeout
|TracerouteStepFinished |int **step**, String **ip**, int **latency**|End of trace
|TracerouteStepFailed |String **error**|Trace error

### Screenshot

![Example screenshot](https://github.com/youssef-fk/flutter_traceroute/blob/main/example/example.jpg?raw=true)

## Contributing

Pull requests are welcome!

## License

[MIT](https://github.com/youssef-fk/flutter_traceroute/blob/master/LICENSE)
