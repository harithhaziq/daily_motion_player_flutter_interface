import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'daily_motion_player_flutter_interface_method_channel.dart';

abstract class DailyMotionPlayerFlutterInterfacePlatform extends PlatformInterface {
  /// Constructs a DailyMotionPlayerFlutterInterfacePlatform.
  DailyMotionPlayerFlutterInterfacePlatform() : super(token: _token);

  static final Object _token = Object();

  static DailyMotionPlayerFlutterInterfacePlatform _instance = MethodChannelDailyMotionPlayerFlutterInterface();

  /// The default instance of [DailyMotionPlayerFlutterInterfacePlatform] to use.
  ///
  /// Defaults to [MethodChannelDailyMotionPlayerFlutterInterface].
  static DailyMotionPlayerFlutterInterfacePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DailyMotionPlayerFlutterInterfacePlatform] when
  /// they register themselves.
  static set instance(DailyMotionPlayerFlutterInterfacePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
