package com.lol.daily_motion_player_flutter_interface

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class DailymotionPlayerViewFactory(
    private val messenger: BinaryMessenger,
    private val context: Context
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, id: Int, creationParams: Any?): PlatformView {
        // Cast creationParams from Any? to Map<*, *>? safely
        val params = creationParams as? Map<*, *>

        val channelName = params?.get("channelName") as? String
            ?: "dailymotion-player-channel" // fallback for iOS or old code

        return DailymotionPlayerNativeView(
            context = context,
            messenger = messenger,
            id = id,
            creationParams = params, // pass casted Map<*, *>?
            channelName = channelName
        )
    }
}


