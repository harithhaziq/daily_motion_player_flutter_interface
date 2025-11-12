import Foundation
import UIKit
import DailymotionPlayerSDK
import SwiftUI
import AVFoundation


// Try each of these in your DailymotionPlayerController.swift
import Flutter
import DailymotionPlayerSDK



class DailymotionPlayerController: UIViewController, ObservableObject, DMVideoDelegate, DMAdDelegate{

    var playerId: String?
    var videoId: String = ""

    var _parent: UIView
    var playerView: DMPlayerView?
    var parameters: DMPlayerParameters?

    private var playerWrapper: UIView?
    var onPlayerReady: (() -> Void)?
    private var shouldPlayWhenReady = false


    // Initialize the class with playerId and videoId
    init(parent: UIView, playerId: String?, videoId: String, parameters: DMPlayerParameters? = nil) {
        self._parent = parent
        self.playerId = playerId
        self.videoId = videoId
        self.parameters = parameters ?? DMPlayerParameters(mute: false, defaultFullscreenOrientation: .portrait)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerWrapper = UIView()
        Task {
            await initPlayer()
        }
    }


    func initPlayer(with parameters: DMPlayerParameters? = nil) async {
        do {
            let playerView = try await Dailymotion.createPlayer(playerId: playerId ?? "xix5x", videoId: videoId, playerParameters: (parameters ?? self.parameters)!, playerDelegate: self, videoDelegate: self, adDelegate: self, logLevels: [.all])


            addPlayerView(playerView: playerView)
        } catch {
            handlePlayerError(error: error)
        }
    }


    private func addPlayerView(playerView: DMPlayerView) {
        self.playerView = playerView

        /**
         Add playerView into player wrapper
         */
        self.playerWrapper!.addSubview(playerView)

        /**
         Adjust the wraper frame to follow parent frame
         */
        self.playerWrapper?.frame = self._parent.frame

        /**
         Add player wrapper as a subview of a parent
         */
        self._parent.addSubview(self.playerWrapper!)


        let constraints = [
            playerView.topAnchor.constraint(equalTo: playerWrapper?.topAnchor ?? self._parent.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: playerWrapper?.bottomAnchor ?? self._parent.bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: playerWrapper?.leadingAnchor ?? self._parent.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: playerWrapper?.trailingAnchor ?? self._parent.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        print("Player view added", self.playerView!)


    }

    func play() {
        if self.playerView != nil {
            print("▶️ Playing immediately - player is ready")
            self.playerView?.play()
        } else {
            print("⏳ Player not ready yet, will play when ready")
            shouldPlayWhenReady = true
        }
    }

    func pause() {
        print("⏸ Pause called")
        // Cancel deferred play if it was requested
        shouldPlayWhenReady = false
        self.playerView?.pause()
    }

    func load(videoId: String) {
        self.playerView?.loadContent(videoId: videoId)
    }

    func handlePlayerError(error: Error) {
        switch(error) {
        case PlayerError.advertisingModuleMissing :
            break;
        case PlayerError.stateNotAvailable :
            break;
        case PlayerError.underlyingRemoteError(error: let error):
            let error = error as NSError
            if let errDescription = error.userInfo[NSLocalizedDescriptionKey],
               let errCode = error.userInfo[NSLocalizedFailureReasonErrorKey],
               let recovery = error.userInfo[NSLocalizedRecoverySuggestionErrorKey] {
                print("Player Error : Description: \(errDescription), Code: \(errCode), Recovery : \(recovery) ")

            } else {
                print("Player Error : \(error)")
            }
            break
        case PlayerError.requestTimedOut:
            print(error.localizedDescription)
            break
        case PlayerError.unexpected:
            print(error.localizedDescription)
            break
        case PlayerError.internetNotConnected:
            print(error.localizedDescription)
            break
        case PlayerError.playerIdNotFound:
            print(error.localizedDescription)
            break
        case PlayerError.otherPlayerRequestError:
            print(error.localizedDescription)
            break
        default:
            print(error.localizedDescription)
            break
        }
    }
}


extension DailymotionPlayerController: DMPlayerDelegate {
    func player(_ player: DailymotionPlayerSDK.DMPlayerView, openUrl url: URL) {

    }

    func playerDidRequestFullscreen(_ player: DMPlayerView) {
        print("🎬 Fullscreen requested")

        // Find the presenting view controller
        guard let presentingVC = playerWillPresentFullscreenViewController(player) else {
            print("⚠️ No presenting view controller found")
            return
        }

        // Create a fullscreen view controller
        let fullscreenVC = UIViewController()
        fullscreenVC.view.backgroundColor = .black
        fullscreenVC.modalPresentationStyle = .fullScreen

        // Remove player from current wrapper
        player.removeFromSuperview()

        // Add player to fullscreen view controller
        fullscreenVC.view.addSubview(player)
        player.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            player.topAnchor.constraint(equalTo: fullscreenVC.view.topAnchor),
            player.bottomAnchor.constraint(equalTo: fullscreenVC.view.bottomAnchor),
            player.leadingAnchor.constraint(equalTo: fullscreenVC.view.leadingAnchor),
            player.trailingAnchor.constraint(equalTo: fullscreenVC.view.trailingAnchor)
        ])

        // Present fullscreen
        presentingVC.present(fullscreenVC, animated: true) {
            // Notify the player that fullscreen is now active
            player.notifyFullscreenChanged()
        }
    }

    func playerDidExitFullScreen(_ player: DMPlayerView) {
        print("🎬 Exit fullscreen")

        // Dismiss the fullscreen view controller
        if let presentedVC = player.window?.rootViewController?.presentedViewController {
            // Remove player from fullscreen view controller
            player.removeFromSuperview()

            presentedVC.dismiss(animated: true) {
                // Re-add player to original wrapper
                self.playerWrapper?.addSubview(player)
                player.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    player.topAnchor.constraint(equalTo: self.playerWrapper!.topAnchor),
                    player.bottomAnchor.constraint(equalTo: self.playerWrapper!.bottomAnchor),
                    player.leadingAnchor.constraint(equalTo: self.playerWrapper!.leadingAnchor),
                    player.trailingAnchor.constraint(equalTo: self.playerWrapper!.trailingAnchor)
                ])

                // Notify the player that fullscreen is now inactive
                player.notifyFullscreenChanged()
            }
        }
    }

    func playerWillPresentFullscreenViewController(_ player: DMPlayerView) -> UIViewController? {
        // Find the root view controller (FlutterViewController) to present fullscreen
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            return rootViewController
        }
        // Fallback: traverse up the responder chain to find FlutterViewController
        var responder: UIResponder? = self._parent
        while responder != nil {
            if let viewController = responder as? UIViewController {
                // Return the top-most view controller in hierarchy
                var topController = viewController
                while let presented = topController.presentedViewController {
                    topController = presented
                }
                return topController
            }
            responder = responder?.next
        }
        return self
    }

    func playerWillPresentAdInParentViewController(_ player: DMPlayerView) -> UIViewController {
        // Find the FlutterViewController in the responder chain
        var responder: UIResponder? = self._parent
        while responder != nil {
            if let flutterVC = responder as? UIViewController {
                return flutterVC
            }
            responder = responder?.next
        }
        // Fallback to self if no FlutterViewController found
        return self
    }

    func player(_ player: DMPlayerView, didChangeVideo changedVideoEvent: PlayerVideoChangeEvent) {
        print( "--playerDidChangeVideo")
    }

    func player(_ player: DMPlayerView, didChangeVolume volume: Double, _ muted: Bool) {
        print( "--playerDidChangeVolume")
    }

    func playerDidCriticalPathReady(_ player: DMPlayerView) {
        print("✅ playerDidCriticalPathReady - Player is now ready!")

        // Notify that player is ready
        onPlayerReady?()

        // If play was requested before player was ready, play now
        if shouldPlayWhenReady {
            print("▶️ Auto-playing deferred play request")
            shouldPlayWhenReady = false
            player.play()
        }
    }

    func player(_ player: DMPlayerView, didReceivePlaybackPermission playbackPermission: PlayerPlaybackPermission) {
        print( "--playerDidReceivePlaybackPermission")
    }

    func player(_ player: DMPlayerView, didChangePresentationMode presentationMode: DMPlayerView.PresentationMode) {
        print( "--playerDidChangePresentationMode", player.isFullscreen)
    }

    func player(_ player: DMPlayerView, didChangeScaleMode scaleMode: String) {
        print( "--playerDidChangeScaleMode")
    }
}

