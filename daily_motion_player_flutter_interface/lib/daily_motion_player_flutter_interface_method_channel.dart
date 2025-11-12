import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'daily_motion_player_flutter_interface_platform_interface.dart';

/// An implementation of [DailyMotionPlayerFlutterInterfacePlatform] that uses method channels.
class MethodChannelDailyMotionPlayerFlutterInterface extends DailyMotionPlayerFlutterInterfacePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('daily_motion_player_flutter_interface');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
