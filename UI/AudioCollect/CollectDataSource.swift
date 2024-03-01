//
//  CollectDataSource.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/3/1.
//

import UIKit
import CoreData

class CollectDataSource {
    static let shared = CollectDataSource()
    enum Types: Int16 {
        case Album = 1
        case Artist = 2
        
        var defaultIcon: String {
            switch self {
            case .Album: return "icon_album"
            case .Artist: return "icon_artist"
            }
        }
        
        var name: String {
            switch self {
            case .Album: return "专辑"
            case .Artist: return "歌手"
            }
        }
    }
    
    private var albums: [CollectModel] = []
    private var artists: [CollectModel] = []
    
    private init() {
        
        albums = (try? CoreDataContext.fetch(AlbumModel.fetchRequest())) ?? []
        artists = (try? CoreDataContext.fetch(ArtistModel.fetchRequest())) ?? []
    }
    

    func getList(with type: Types) -> [CollectModel] {
        switch type {
        case .Album: return albums
        case .Artist: return artists
        }
    }
    
    static func deleteAudio(model: AudioModel) {
        deleteArtist(model: model)
        deleteAlbum(model: model)
    }

    static func deleteArtist(model: AudioModel) {
        let result = shared.artists.filter { $0.name == model.artist }
        
        if result.count == 1 {
            result[0].removeFromAudio(model)
        }
    }
    
    static func deleteAlbum(model: AudioModel) {
        let result = shared.albums.filter { $0.name == model.album }
        
        if result.count == 1 {
            result[0].removeFromAudio(model)
        }
    }
    
    static func pushAudio(_ audio: AudioModel) {
        pushAlbum(with: audio)
        pushArtist(with: audio)
    }
    
    static func pushAlbum(with audio: AudioModel) {
        guard let albumName = audio.album, albumName.isEmpty == false else {return}

        let resultAlbum = shared.albums.filter { album in
            return album.name == albumName
        }

        if resultAlbum.count == 1 {
            resultAlbum[0].pushAudio(audio)
        } else {
            let albumModel = AlbumModel(context: CoreDataContext)
            albumModel.name = albumName
            albumModel.pushAudio(audio)
            shared.albums.append(albumModel)
        }
    }
    
    static func pushArtist(with audio: AudioModel) {
        guard let artistName = audio.artist, artistName.isEmpty == false else {return}

        let resultArtist = shared.artists.filter { artist in
            return artist.name == artistName
        }
        if resultArtist.count == 1 {
            resultArtist[0].pushAudio(audio)
        } else {
            let artistModel = ArtistModel(context: CoreDataContext)
            artistModel.name = artistName
            artistModel.pushAudio(audio)
            shared.artists.append(artistModel)
        }
    }
}
