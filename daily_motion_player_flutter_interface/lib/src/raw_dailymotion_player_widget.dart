// ignore: file_names
import 'package:daily_motion_player_flutter_interface/src/dailymotion_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class RawDailymotionPlayerWidget extends StatelessWidget {
  // ignore: slash_for_doc_comments
  /**
   *  initiate DailymotionPlayerController
   * */
  final DailymotionPlayerController controller;
  final double height;
  final double width;

  const RawDailymotionPlayerWidget({super.key, required this.controller, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    /**
     * the plugin view type
     */
    const String viewType = 'dailymotion-player-view';

    return SizedBox(
      height: height,
      width: width,
      child: Platform.isAndroid
          ?
      /**
       * show AndroidView if it's androi
       */

      AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: {
          "videoId": controller.videoId,
          "playerId": controller.playerId,
          'channelName': controller.channelName,
        },
        creationParamsCodec: const StandardMessageCodec(),
      )
          :
      /**
       * Show UiKitView if it's iOS
       */
      UiKitView(
        key: super.key,
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: {
          "videoId": controller.videoId,
          "playerId": controller.playerId,
          'channelName': controller.channelName,
        },
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
