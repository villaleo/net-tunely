//
//  Album.swift
//  lab-tunley
//
//  Created by Leonardo Villalobos on 2/22/23.
//

import Foundation

struct AlbumsSearchResponse: Decodable {
    let results: [Album]
}

struct Album: Decodable {
    let artworkUrl100: URL
}
