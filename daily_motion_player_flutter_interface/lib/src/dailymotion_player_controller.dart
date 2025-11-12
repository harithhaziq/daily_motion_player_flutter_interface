import 'package:flutter/services.dart';
import 'dart:developer' as developer;


class DailymotionPlayerController {
  final String videoId;
  final String playerId;
  final String channelName; // now pass it in
  late final MethodChannel _methodChannel;

  DailymotionPlayerController({
    required this.videoId,
    required this.playerId,
    required this.channelName, // pass from outside
  }) {
    // Use passed channelName to create MethodChannel
    _methodChannel = MethodChannel(channelName);
  }


  Future<void> play() async {
    try {
      await _methodChannel.invokeMethod('play');
    } on PlatformException catch (e) {
      developer.log("Failed to play video: '${e.message}'.");
    }
  }


  Future<void> pause() async {
    try {
      await _methodChannel.invokeMethod('pause');
    } on PlatformException catch (e) {
      developer.log("Failed to pause video: '${e.message}'.");
    }
  }

  Future<void> load(String videoId) async {
    try {
      await _methodChannel.invokeMethod('load', {'videoId': videoId});
    } on PlatformException catch (e) {
      developer.log("Failed to load video: '${e.message}'.");
    }
  }

  Future<void> seek(double seconds) async {
    try {
      await _methodChannel.invokeMethod('seek', {'seconds': seconds});
    } on PlatformException catch (e) {
      developer.log("Failed to seek video: '${e.message}'.");
    }
  }

  Future<void> replay() async {
    try {
      await _methodChannel.invokeMethod('replay');
    } on PlatformException catch (e) {
      developer.log("Failed to replay video: '${e.message}'.");
    }
  }

  Future<double?> getVideoDuration() async {
    try {
      final dynamic duration = await _methodChannel.invokeMethod('getVideoDuration');
      if (duration is int) {
        return duration.toDouble();
      }
      return duration as double?;
    } on PlatformException catch (e) {
      developer.log("Failed to get video duration: '${e.message}'.");
      return null;
    }
  }

  Future<double?> getVideoCurrentTimestamp() async {
    try {
      final dynamic timestamp =
      await _methodChannel.invokeMethod('getVideoCurrentTimestamp');

      if (timestamp is int) return timestamp.toDouble();
      if (timestamp is double) return timestamp;

      developer.log("Unexpected timestamp type: ${timestamp.runtimeType}");
      return null;
    } on PlatformException catch (e) {
      developer.log("Failed to get current timestamp: '${e.message}'.");
      return null;
    }
  }



  Future<bool?> playerIsBuffering() async {
    try {
      final isBuffering = await _methodChannel.invokeMethod<bool>('playerIsBuffering');
      return isBuffering;
    } on PlatformException catch (e) {
      developer.log("Failed to get buffering status: '${e.message}'.");
      return null;
    }
  }

  Future<bool?> playerIsPlaying() async {
    try {
      final isPlaying = await _methodChannel.invokeMethod<bool>('playerIsPlaying');
      return isPlaying;
    } on PlatformException catch (e) {
      developer.log("Failed to get playing status: '${e.message}'.");
      return null;
    }
  }


  Future<bool?> playerIsReplayScreen() async {
    try {
      final isPlaying = await _methodChannel.invokeMethod<bool>('playerIsReplayScreen');
      return isPlaying;
    } on PlatformException catch (e) {
      developer.log("Failed to get playerIsReplayScreen status: '${e.message}'.");
      return null;
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    developer.log("inkwe");
    await _methodChannel.invokeMethod('setPlaybackSpeed', {'speed': speed});
  }

  Future<void> updatePlayerParams({
    bool? mute,
    double? volume,
    bool? enableControls,
    String? scaleMode, // e.g. "aspectFit", "aspectFill", "fill"
  }) async {
    final params = <String, dynamic>{
      if (mute != null) 'mute': mute,
      if (volume != null) 'volume': volume,
      if (enableControls != null) 'enableControls': enableControls,
      if (scaleMode != null) 'scaleMode': scaleMode,
    };

    await _methodChannel.invokeMethod('updatePlayerParams', params);
  }

  Future<void> setMute() async {
    try {
      await _methodChannel.invokeMethod('setMute');
    } on PlatformException catch (e) {
      developer.log("Failed setMute: '${e.message}'.");
    }
  }

  Future<void> setUnMute() async {
    try {
      await _methodChannel.invokeMethod('setUnMute');
    } on PlatformException catch (e) {
      developer.log("Failed setUnMute: '${e.message}'.");
    }
  }

  Future<void> setPlaybackSpeed25() async {
    try {
      await _methodChannel.invokeMethod('setPlaybackSpeed25');
    } on PlatformException catch (e) {
      developer.log("Failed setPlaybackSpeed25: '${e.message}'.");
    }
  }


  Future<void> setPlaybackSpeed50() async {
    try {
      await _methodChannel.invokeMethod('setPlaybackSpeed50');
    } on PlatformException catch (e) {
      developer.log("Failed setPlaybackSpeed50: '${e.message}'.");
    }
  }

  Future<void> setPlaybackSpeed75() async {
    try {
      await _methodChannel.invokeMethod('setPlaybackSpeed75');
    } on PlatformException catch (e) {
      developer.log("Failed setPlaybackSpeed75: '${e.message}'.");
    }
  }

  Future<void> setPlaybackSpeed100() async {
    try {
      await _methodChannel.invokeMethod('setPlaybackSpeed100');
    } on PlatformException catch (e) {
      developer.log("Failed setPlaybackSpeed100: '${e.message}'.");
    }
  }

  Future<void> setPlaybackSpeed125() async {
    try {
      await _methodChannel.invokeMethod('setPlaybackSpeed125');
    } on PlatformException catch (e) {
      developer.log("Failed setPlaybackSpeed125: '${e.message}'.");
    }
  }

  Future<void> setPlaybackSpeed150() async {
    try {
      await _methodChannel.invokeMethod('setPlaybackSpeed150');
    } on PlatformException catch (e) {
      developer.log("Failed setPlaybackSpeed150: '${e.message}'.");
    }
  }

  Future<void> setPlaybackSpeed175() async {
    try {
      await _methodChannel.invokeMethod('setPlaybackSpeed175');
    } on PlatformException catch (e) {
      developer.log("Failed setPlaybackSpeed175: '${e.message}'.");
    }
  }

  Future<void> setPlaybackSpeed200() async {
    try {
      await _methodChannel.invokeMethod('setPlaybackSpeed200');
    } on PlatformException catch (e) {
      developer.log("Failed setPlaybackSpeed200: '${e.message}'.");
    }
  }



}
