//
//  Album.swift
//  POCRxSwiftErrorHandling
//
//  Created by Punde, Rasika Nanasaheb on 03/06/20.
//  Copyright © 2020 Punde, Rasika Nanasaheb (US - Mumbai). All rights reserved.
//

import Foundation

struct Album: Codable {

    let id, name, albumArtWork, artist: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case albumArtWork = "album_art_work"
        case artist
    }
}

// MARK: Convenience initializers
extension Album {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Album.self, from: data) else { return nil }
        self = me
    }
}
