import Flutter
import UIKit
import DailymotionPlayerSDK
import SwiftUI

class DailymotionPlayerViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        var channelName = "dailymotion-player-channel"
        if let argsDict = args as? [String: Any],
               let customChannelName = argsDict["channelName"] as? String {
                channelName = customChannelName
            }

        let nativeView = DailymotionPlayerNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
        // Register method channel
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak nativeView] (call, result) in
            if call.method == "play" {
                nativeView?.play()
                result(nil)

            } else if call.method == "pause" {
                nativeView?.pause()
                result(nil)

            } else if call.method == "setMute" {
                nativeView?.setMute()
                result(nil)
            } else if call.method == "setUnMute" {
                nativeView?.setUnMute()
                result(nil)

            } else if call.method == "load",
                      let args = call.arguments as? [String: Any],
                      let videoId = args["videoId"] as? String {
                nativeView?.load(videoId: videoId)
                result(nil)

            } else if call.method == "seek",
                      let args = call.arguments as? [String: Any],
                      let seconds = args["seconds"] as? Double {
                nativeView?.seek(to: seconds)
                result(nil)


            } else if call.method == "setPlaybackSpeed",
                      let args = call.arguments as? [String: Any],
                      let seconds = args["seconds"] as? Double {
                nativeView?.setPlaybackSpeed(to: seconds)
                result(nil)

            } else if call.method == "replay" {
                nativeView?.replay()
                result(nil)

            } else if call.method == "getVideoDuration" {
                nativeView?.getVideoDuration { duration in
                    if let duration = duration {
                        result(duration)
                    } else {
                        result(FlutterError(code: "NATIVE_ERROR", message: "Failed to get video duration", details: nil))
                    }
                }

            } else if call.method == "getVideoCurrentTimestamp" {
                nativeView?.getVideoCurrentTimestamp { timestamp in
                    if let timestamp = timestamp {
                        result(timestamp)
                    } else {
                        result(FlutterError(code: "NATIVE_ERROR", message: "Failed to get current timestamp", details: nil))
                    }
                }

            } else if call.method == "playerIsBuffering" {
                nativeView?.playerIsBuffering { isBuffering in
                    if let isBuffering = isBuffering {
                        result(isBuffering)
                    } else {
                        result(FlutterError(code: "NATIVE_ERROR", message: "Failed to get buffering status", details: nil))
                    }
                }



            } else if call.method == "playerIsPlaying" {
                nativeView?.playerIsPlaying { isPlaying in
                    if let isPlaying = isPlaying {
                        result(isPlaying)
                    } else {
                        result(FlutterError(code: "NATIVE_ERROR", message: "Failed to get playing status", details: nil))
                    }
                }
            } else if call.method == "playerIsReplayScreen" {
                nativeView?.playerIsReplayScreen { isPlaying in
                    if let isPlaying = isPlaying {
                        result(isPlaying)
                    } else {
                        result(FlutterError(code: "NATIVE_ERROR", message: "Failed to get playerIsReplayScreen status", details: nil))
                    }
                }
            } else if call.method == "setPlaybackSpeed25" {
                nativeView?.setPlaybackSpeed25()
                result(nil)
            } else if call.method == "setPlaybackSpeed50" {
                nativeView?.setPlaybackSpeed50()
                result(nil)
            } else if call.method == "setPlaybackSpeed75" {
                nativeView?.setPlaybackSpeed75()
                result(nil)
            } else if call.method == "setPlaybackSpeed100" {
                nativeView?.setPlaybackSpeed100()
                result(nil)
            } else if call.method == "setPlaybackSpeed125" {
                nativeView?.setPlaybackSpeed125()
                result(nil)
            } else if call.method == "setPlaybackSpeed150" {
                nativeView?.setPlaybackSpeed150()
                result(nil)
            } else if call.method == "setPlaybackSpeed175" {
                nativeView?.setPlaybackSpeed175()
                result(nil)
            } else if call.method == "setPlaybackSpeed200" {
                nativeView?.setPlaybackSpeed200()
                result(nil)
            } else if call.method == "updatePlayerParams" {
                // Handle updatePlayerParams method
                if let args = call.arguments as? [String: Any] {
                    let mute = args["mute"] as? Bool ?? false
                    let volume = args["volume"] as? Int ?? 100

                    if mute {
                        nativeView?.setMute()
                    } else {
                        nativeView?.setUnMute()
                    }
                    // Note: Volume control and enableControls would need additional implementation
                    // in DailymotionPlayerNativeView if the SDK supports them
                }
                result(nil)
            } else if call.method == "isReady" {
                // Check if player is ready
                let isReady = nativeView?.isPlayerReady() ?? false
                result(isReady)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }


        return nativeView
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class DailymotionPlayerNativeView: NSObject, FlutterPlatformView{
    private var _view: UIView
    var _videoId: String
    var _playerId: String
    let dailymotionPlayerController: DailymotionPlayerController
    private var methodChannel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        // Check if args is a dictionary and cast it to [String: Any]
        if let argsDict = args as? [String: Any] {
            // Retrieve videoId and playerId from argsDict
            _videoId = argsDict["videoId"] as? String ?? ""
            _playerId = argsDict["playerId"] as? String ?? ""
        } else {
            // Set default values if args is nil or not a dictionary
            _videoId = ""
            _playerId = ""
        }


        let defaultParameters = DMPlayerParameters(
            scaleMode: .fit,
            mute: false,
            loop: false,
            allowIDFA: false,
            allowPIP: false,
            defaultFullscreenOrientation: .portrait

        )




        // Create an instance of DailymotionPlayerController
        self.dailymotionPlayerController = DailymotionPlayerController(parent: _view, playerId: _playerId, videoId: _videoId, parameters: defaultParameters)


        super.init()


        //
        //
        //        // iOS views can be created here
        //        createNativeView(view: _view)
    }

    func view() -> UIView {
        //         Add the Dailymotion player's view as a subview to the provided _view
        if let playerView = dailymotionPlayerController.view {
            playerView.frame = _view.bounds
            playerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            _view.addSubview(playerView)
            return _view

        } else {
            print("Error: Dailymotion player's view is nil")
        }
        return _view
    }

    func play() {
        print("📱 play() called - playerView is \(dailymotionPlayerController.playerView != nil ? "ready" : "nil")")
        dailymotionPlayerController.play()
    }

    func pause() {
        print("📱 pause() called - playerView is \(dailymotionPlayerController.playerView != nil ? "ready" : "nil")")
        dailymotionPlayerController.pause()
    }

    func load(videoId:String) {
        dailymotionPlayerController.load(videoId: videoId)
    }

    func seek(to seconds: Double) {
        dailymotionPlayerController.playerView?.seek(to: seconds)
    }

    func replay() {
        dailymotionPlayerController.playerView?.seek(to: 0)
        dailymotionPlayerController.play()
    }

    func getVideoDuration(completion: @escaping (Double?) -> Void) {
        dailymotionPlayerController.playerView?.getState { state in
            completion(state?.videoDuration)
        }
    }

    func getVideoCurrentTimestamp(completion: @escaping (Double?) -> Void) {
        dailymotionPlayerController.playerView?.getState { state in
            completion(state?.videoTime)
        }
    }

    func playerIsBuffering(completion: @escaping (Bool?) -> Void) {
        dailymotionPlayerController.playerView?.getState { state in
            completion(state?.playerIsBuffering)
        }
    }

    func playerIsPlaying(completion: @escaping (Bool?) -> Void) {
        dailymotionPlayerController.playerView?.getState { state in
            completion(state?.playerIsPlaying)
        }
    }

    func playerIsReplayScreen(completion: @escaping (Bool?) -> Void) {
        dailymotionPlayerController.playerView?.getState { state in
            completion(state?.playerIsReplayScreen)
        }
    }

    func setPlaybackSpeed(to seconds: Double) {
        dailymotionPlayerController.playerView?.setPlaybackSpeed(speed: seconds)
    }


    func setMute() {
        dailymotionPlayerController.playerView?.setMute(mute: true)
    }

    func setUnMute() {
        dailymotionPlayerController.playerView?.setMute(mute: false)
    }

    func setPlaybackSpeed25() {
        dailymotionPlayerController.playerView?.setPlaybackSpeed(speed: 0.25)
    }

    func setPlaybackSpeed50() {
        dailymotionPlayerController.playerView?.setPlaybackSpeed(speed: 0.5)
    }

    func setPlaybackSpeed75() {
        dailymotionPlayerController.playerView?.setPlaybackSpeed(speed: 0.75)
    }

    func setPlaybackSpeed100() {
        dailymotionPlayerController.playerView?.setPlaybackSpeed(speed: 1)
    }

    func setPlaybackSpeed125() {
        dailymotionPlayerController.playerView?.setPlaybackSpeed(speed: 1.25)
    }

    func setPlaybackSpeed150() {
        dailymotionPlayerController.playerView?.setPlaybackSpeed(speed: 1.5)
    }

    func setPlaybackSpeed175() {
        dailymotionPlayerController.playerView?.setPlaybackSpeed(speed: 1.75)
    }

    func setPlaybackSpeed200() {
        dailymotionPlayerController.playerView?.setPlaybackSpeed(speed: 2)
    }

    func isPlayerReady() -> Bool {
        let isReady = dailymotionPlayerController.playerView != nil
        print("isPlayerReady check: \(isReady)")
        return isReady
    }


}



