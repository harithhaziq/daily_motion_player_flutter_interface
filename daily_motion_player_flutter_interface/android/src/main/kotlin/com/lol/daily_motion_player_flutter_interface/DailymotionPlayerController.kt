package com.lol.daily_motion_player_flutter_interface

import android.content.Context
import android.util.Log
import android.widget.FrameLayout
import androidx.fragment.app.DialogFragment
import com.dailymotion.player.android.sdk.Dailymotion
import com.dailymotion.player.android.sdk.PlayerView
import com.dailymotion.player.android.sdk.listeners.PlayerListener
import com.dailymotion.player.android.sdk.listeners.VideoListener
import com.dailymotion.player.android.sdk.webview.error.PlayerError
import com.dailymotion.player.android.sdk.webview.events.PlayerEvent

class DailymotionPlayerController(
    context: Context,
    creationParams: Map<*, *>?
) : FrameLayout(context) {

    private lateinit var playerView: PlayerView
    private var videoId: String = creationParams?.get("videoId") as? String ?: ""
    private var playerId: String = creationParams?.get("playerId") as? String ?: ""

    var isBuffering: Boolean = false
        private set
    var isPlaying: Boolean = false
        private set
    var isReplayScreen: Boolean = false
        private set

    private var duration: Long? = null
    private var currentTime: Long? = null

    val logTag = "Dailymotion-Flutter"

    // Event callbacks for Flutter
    var onVideoEnded: (() -> Unit)? = null
    var onPlaybackError: ((String) -> Unit)? = null
    var onBufferingChanged: ((Boolean) -> Unit)? = null

    init {
        Dailymotion.createPlayer(
            context = context,
            playerId = playerId,
            videoId = videoId,
            videoListener = object : VideoListener {
                override fun onVideoDurationChange(playerView: PlayerView, duration: Long) {
                    this@DailymotionPlayerController.duration = duration
                    Log.d(logTag, "Video duration: $duration ms")
                    super.onVideoDurationChange(playerView, duration)
                }

                override fun onVideoProgress(playerView: PlayerView, time: Long) {
                    currentTime = time
                    Log.d(logTag, "Playback time: $time ms")
                    isReplayScreen = false
                    isBuffering = false
                    isPlaying = true
                }

                override fun onVideoEnd(playerView: PlayerView) {
                    Log.d(logTag, "Video ended")
                    isPlaying = false
                    isReplayScreen = true
                    onVideoEnded?.invoke()
                    isBuffering = false
                }


                override fun onVideoBuffering(playerView: PlayerView) {
                    super.onVideoBuffering(playerView)
                    isBuffering = true
                    isReplayScreen = false
                }

                override fun onVideoPause(playerView: PlayerView) {
                    super.onVideoPause(playerView)
                    isPlaying = false
                    isBuffering = false
                    isReplayScreen = false

                }

                override fun onVideoPlaying(playerView: PlayerView) {
                    super.onVideoPlaying(playerView)
                    isPlaying = true
                    isBuffering = false
                    isReplayScreen = false

                }

                override fun onVideoPlay(playerView: PlayerView) {
                    super.onVideoPlay(playerView)
                    isPlaying = true
                    isBuffering = false
                    isReplayScreen = false

                }

                override fun onVideoStart(playerView: PlayerView) {
                    super.onVideoStart(playerView)
                    isPlaying = true
                    isBuffering = false
                    isReplayScreen = false

                }

                override fun onVideoTimeChange(playerView: PlayerView, time: Long) {
                    super.onVideoTimeChange(playerView, time)
                    isPlaying = true
                    isBuffering = false
                    isReplayScreen = false

                }
            },
            playerSetupListener = object : Dailymotion.PlayerSetupListener {
                override fun onPlayerSetupSuccess(player: PlayerView) {
                    playerView = player
                    val lp = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
                    this@DailymotionPlayerController.addView(player, lp)
                    Log.d(logTag, "Dailymotion player ready")
                }

                override fun onPlayerSetupFailed(error: PlayerError) {
                    Log.e(logTag, "Error setting up player: ${error.message}")
                    onPlaybackError?.invoke(error.message ?: "Unknown error")
                }
            },
            playerListener = object : PlayerListener {
                override fun onFullscreenRequested(playerDialogFragment: DialogFragment) {
                    playerDialogFragment.show(
                        (context as androidx.fragment.app.FragmentActivity).supportFragmentManager,
                        "dmPlayerFullscreenFragment"
                    )
                }


            }
        )
    }

    fun play() = playerView.play()
    fun pause() = playerView.pause()
    fun loadVideo(videoId: String) = playerView.loadContent(videoId)
    fun replay() {
        playerView.seekTo(0)
        playerView.play()
    }
    fun seek(seconds: Long) = playerView.seekTo(seconds)

    fun getVideoDuration(): Long? = duration
    fun getVideoCurrentTimestamp(): Long? = currentTime

    fun setPlaybackSpeed(speed: Double) = playerView.setPlaybackSpeed(speed)
    fun mute() = playerView.setMute(true)
    fun unMute() = playerView.setMute(false)

    fun dispose() {
        playerView.destroy()
    }
}
