package com.lol.daily_motion_player_flutter_interface

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import android.util.Log


class DailymotionPlayerNativeView(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    creationParams: Map<*, *>?,
    channelName: String
) : PlatformView, MethodChannel.MethodCallHandler {

    private val methodChannel = MethodChannel(messenger, channelName)
    private val dailymotionPlayerController = DailymotionPlayerController(context, creationParams)

    init {
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View = dailymotionPlayerController

    override fun dispose() {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "play" -> dailymotionPlayerController.play().also { result.success(null) }
                "pause" -> dailymotionPlayerController.pause().also { result.success(null) }
                "load" -> {
                    val videoId = call.argument<String>("videoId")
                    if (!videoId.isNullOrEmpty()) {
                        dailymotionPlayerController.loadVideo(videoId)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "videoId is required", null)
                    }
                }
                "seek" -> {
                    val seconds = call.argument<Number>("seconds")?.toLong() ?: 0L
                    dailymotionPlayerController.seek(seconds)
                    result.success(null)
                }
                "replay" -> dailymotionPlayerController.replay().also { result.success(null) }
                "getVideoDuration" -> result.success(dailymotionPlayerController.getVideoDuration())
                "getVideoCurrentTimestamp" -> result.success(dailymotionPlayerController.getVideoCurrentTimestamp())
                "playerIsBuffering" -> result.success(dailymotionPlayerController.isBuffering)
                "playerIsPlaying" -> result.success(dailymotionPlayerController.isPlaying)
                "playerIsReplayScreen" -> result.success(dailymotionPlayerController.isReplayScreen)
                "setPlaybackSpeed" -> {
                    val speed = call.argument<Double>("speed") ?: 1.0
                    dailymotionPlayerController.setPlaybackSpeed(speed)
                    result.success(null)
                }
                "setMute" -> dailymotionPlayerController.mute().also { result.success(null) }
                "setUnMute" -> dailymotionPlayerController.unMute().also { result.success(null) }

// Quick speed presets
                "setPlaybackSpeed25" -> dailymotionPlayerController.setPlaybackSpeed(0.25).also { result.success(null) }
                "setPlaybackSpeed50" -> dailymotionPlayerController.setPlaybackSpeed(0.5).also { result.success(null) }
                "setPlaybackSpeed75" -> dailymotionPlayerController.setPlaybackSpeed(0.75).also { result.success(null) }
                "setPlaybackSpeed100" -> dailymotionPlayerController.setPlaybackSpeed(1.0).also { result.success(null) }
                "setPlaybackSpeed125" -> dailymotionPlayerController.setPlaybackSpeed(1.25).also { result.success(null) }
                "setPlaybackSpeed150" -> dailymotionPlayerController.setPlaybackSpeed(1.5).also { result.success(null) }
                "setPlaybackSpeed175" -> dailymotionPlayerController.setPlaybackSpeed(1.75).also { result.success(null) }
                "setPlaybackSpeed200" -> dailymotionPlayerController.setPlaybackSpeed(2.0).also { result.success(null) }

                else -> {
                    Log.w("DailymotionPlayerNativeView", "Method not implemented: ${call.method}")
                    result.notImplemented()
                }

            }
        } catch (e: Exception) {
            result.error("NATIVE_ERROR", e.message, null)
        }
    }
}
