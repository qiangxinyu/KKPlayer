//
//  Player.swift
//  Player
//
//  Created by 强新宇 on 2022/3/17.
//


import AVKit
import MediaPlayer



extension PlayerManager {
    
    static func regist() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    class Player: NSObject, AVAudioPlayerDelegate {
        private var startTime: TimeInterval = 0
        private var playTime: TimeInterval = 0
        
        private let commandCenter = MPRemoteCommandCenter.shared()

        private var player: AVAudioPlayer? {
            didSet {  oldValue?.stop()  }
        }
        
        lazy private var timer: Timer = {
            let t = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] _ in
                if let player = self?.player {
                    PlayerManager.currentPlayerTime = player.currentTime
                }
            }
            
            RunLoop.main.add(t, forMode: .common)
            
            return t
        }()
                
            
        override init() {
            super.init()
            
            let _ = timer.isValid
            
            NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())

            
            commandCenter.playCommand.addTarget { _ in
                PlayerManager.play()
                return .success
            }
            
            commandCenter.pauseCommand.addTarget { _ in
                PlayerManager.pause()
                return .success
            }
            
            commandCenter.changePlaybackPositionCommand.addTarget { event in
                if let e = event as? MPChangePlaybackPositionCommandEvent {
                    PlayerManager.seek(to: e.positionTime)
                    PlayerManager.play()
                    return .success

                }
                return .commandFailed
            }
           
            
            commandCenter.nextTrackCommand.addTarget { event in
                PlayerManager.next()
                return .success
            }
            
            commandCenter.previousTrackCommand.addTarget { event in
                PlayerManager.previous()
                return .success
            }
        }
        
        func seek(to: TimeInterval) {
            player?.currentTime = to
            PlayerManager.currentPlayerTime = to
            updateNowPlaying()
        }
        
        
        func play(model: AudioModel) {
            player?.stop()
            do {
                
                player = try AVAudioPlayer(contentsOf: model.path.url)
                player?.numberOfLoops = 0
                player?.volume = 1
                player?.prepareToPlay()
                player?.delegate = self

                playTime = 0
                
                PlayerManager.currentPlayerTime = 0
                PlayerManager.duration = player?.duration ?? 0
                PlayerManager.currentModel = model

                play()

            } catch {
                UIAlertController.show(title: error.localizedDescription)
            }
        }
        
     
        func replay() {
            player?.stop()
            player?.currentTime = 0
            
            checkPlayCount()
            
            playTime = 0
            play()
        }
        
     
        func play() {
            if let player = player, player.play() {
                
                PlayerManager.isPlaying = true
                startTime = Date().timeIntervalSince1970
                
                updateNowPlaying()
     
            } else {
                UIAlertController.show(title: "\(PlayerManager.currentModel?.name ?? "") 无法播放 未知原因")
            }
        }
        
        
        func pause() {
            PlayerManager.isPlaying = false
            player?.pause()
            updateNowPlaying()
            calculateTime()
        }
        
        
        @objc func handleInterruption(notification: Notification) {
            guard let userInfo = notification.userInfo,
                let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                    return
            }

            switch type {
            case .began: pause()
            case .ended: play()
            default: break
            }
        }
        
        @objc func audioRouteChange(noti: Notification) {
            if let state = noti.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt {
                switch state {
                case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue: break
                case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue: pause()
                default: break
                }
            }
        }
        
        
        func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
            UIAlertController.show(title: error?.localizedDescription ?? "player error")
        }
        
        
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    //        if AutoStopVC.isStop {
    //            AutoStopVC.isStop = false
    //            pause()
    //            return
    //        }
            next()
        }

        
        func updateNowPlaying() {
            
            guard let player = player, let model = PlayerManager.currentModel else {return}
            
            var nowPlayingInfo = [String : Any]()
            nowPlayingInfo[MPMediaItemPropertyTitle] = model.name
            nowPlayingInfo[MPMediaItemPropertyArtist] = model.artist

            if let image = model.artworkImage {
                nowPlayingInfo[MPMediaItemPropertyArtwork] =  MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
                }
            }
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.duration
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
        
        
        func calculateTime() {
            playTime += Date().timeIntervalSince1970 - startTime
        }
        
        func checkPlayCount() {
            calculateTime()
            
            if PlayerManager.duration > 0, playTime >= PlayerManager.duration * 0.9 {
                PlayerManager.currentModel?.playCountAddOne()
                try? CoreDataContext.save()
            }
            
        }
    }

}

