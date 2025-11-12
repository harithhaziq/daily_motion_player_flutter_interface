package com.lol.daily_motion_player_flutter_interface

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** DailyMotionPlayerFlutterInterfacePlugin */
class DailyMotionPlayerFlutterInterfacePlugin : FlutterPlugin {

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    binding.platformViewRegistry.registerViewFactory(
      "dailymotion-player-view",
      DailymotionPlayerViewFactory(
        messenger = binding.binaryMessenger,
        context = binding.applicationContext
      )
    )
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}
