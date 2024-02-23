//
//  PlayerManager.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/7.
//

import SwiftUI


typealias Change = () -> Void


class PlayerManager {

    private init() {}
    
    /// 播放列表
    static let playerList = PlayerList()
    /// 播放器
    static let player = Player()
    
    
    /// 监听的都是不会销毁的视图，所以就不考虑释放的问题
    private static var currentModelChanges = [Change]()
    static func currentModelChange(_ change: @escaping Change) {
        currentModelChanges.append(change)
    }
    /// 全局唯一的现在播放的音乐
    static var currentModel: AudioModel? {
        didSet {
            DispatchQueue.main.async {
                currentModelChanges.forEach { $0() }
            }
        }
    }
    
    
    private static var currentPlayerTimeChanges = [Change]()
    static func currentPlayerTimeChange(_ change: @escaping Change) {
        currentPlayerTimeChanges.append(change)
    }
    /// 当前播放到这首歌的时间
    static var currentPlayerTime: TimeInterval = 0 {
        didSet { currentPlayerTimeChanges.forEach { $0() } }
    }
    
    
    /// 当前歌曲总时长变动 在 current model 改变之前进行改变
    /// 这个回调只有在现实总时长的地方用到，所以在 current model 之前就去改变不会影响逻辑
    private static var durationChanges = [Change]()
    static func durationChange(_ change: @escaping Change) {
        durationChanges.append(change)
    }
    /// 当前歌总时间
    static var duration: TimeInterval = 0 {
        didSet { durationChanges.forEach { $0() } }
    }
    
    
    private static var isPlayingChanges = [Change]()
    static func isPlayingChange(_ change: @escaping Change) {
        isPlayingChanges.append(change)
    }
    /// 当前是否在播放
    static var isPlaying = false {
        didSet {
            DispatchQueue.main.async {
                isPlayingChanges.forEach { $0() }
            }
        }
    }
    
    

    
    static private var playListChanges = [Change]()
    static func playListChange(_ change: @escaping Change) {
        playListChanges.append(change)
    }
    static func playListChangesPost() {
        DispatchQueue.main.async {
            playListChanges.forEach {$0()}
        }
    }
    
    /// 循环方式
    static var loop: PlayerList.Loop = .plain {
        didSet {
            playerList.loop = loop
        }
    }
    
    /// 播放某首歌并同步主页列表到播放列表
    static func play(model: AudioModel, list: [AudioModel]) {
        playerList.play(model: model, list: list)
    }
    
    static func settingPlayList(list: [AudioModel]) {
        playerList.settingPlayList(list: list)

    }
    
    /// 单纯播放某首歌
    static func play(model: AudioModel) {
        playerList.play(model: model)
    }
    
    /// 插入下一首播放
    static func insertNext(models: [AudioModel]) {
        playerList.insertNext(models: models)
    }
    
    static func play() {
        player.play()
    }
    
    static func replay() {
        player.replay()
    }
    
    static func pause() {
        player.pause()
    }
    
    static func stop() {
        player.stop()
    }
    
    static func seek(to: TimeInterval) {
        player.seek(to: to)
    }
    
    static func backward(second: TimeInterval) {
        let targetSecond = currentPlayerTime - second
        player.seek(to: targetSecond < 0 ? 0 : targetSecond)
    }
    static func forward(second: TimeInterval) {
        let targetSecond = currentPlayerTime + second
        if targetSecond > duration {
            next()
        } else {
            player.seek(to: targetSecond)
        }
    }
    static func next() {
        playerList.next()
    }
    
    static func previous() {
        if currentPlayerTime > 5 {
            replay()
        } else {
            playerList.previous()
        }
    }
    
    
    static func clickPlayPauseButton() {
        if isPlaying {
            pause()
        } else {
            if currentModel == nil, HomeDataSource.items.count > 0 {
                play(model: HomeDataSource.items[0], list: HomeDataSource.items)
            } else {
                play()
            }
        }
    }
    
    
    static func deleteItemRefresh(isPlaying: Bool) {
        HomeDataSource.refreshItems()
        
        if HomeDataSource.items.count > 0 {
            
            PlayerManager.settingPlayList(list: HomeDataSource.items)
            
            if isPlaying {
                PlayerManager.currentModel = nil
                PlayerManager.playerList.playWidthIndex()
            }
            
            if !PlayerManager.isPlaying {
                PlayerManager.pause()
            }
        } else {
            PlayerManager.stop()
        }   
    }
}




