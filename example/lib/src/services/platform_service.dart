import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

abstract class IPlatformService {
  static final _instance =
      kIsWeb ? _PlatformServiceWeb() : _PlatformServiceMobile();
  static IPlatformService get instance => _instance;

  bool get isAndroid;
  bool get isIOS;
  bool get isWeb;
}

class _PlatformServiceMobile implements IPlatformService {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isIOS => Platform.isIOS;

  @override
  bool get isWeb => false;
}

class _PlatformServiceWeb implements IPlatformService {
  @override
  bool get isAndroid => false;

  @override
  bool get isIOS => false;

  @override
  bool get isWeb => true;
}
