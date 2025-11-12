// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'daily_motion_player_flutter_interface_platform_interface.dart';

export 'src/dailymotion_player_controller.dart';
export 'src/raw_dailymotion_player_widget.dart';


class DailyMotionPlayerFlutterInterface {
  Future<String?> getPlatformVersion() {
    return DailyMotionPlayerFlutterInterfacePlatform.instance.getPlatformVersion();
  }
}



