//
//  Track.swift
//  HalfTunes
//
//  Created by setsu on 2019/10/20.
//  Copyright © 2019 setsu. All rights reserved.
//

import Foundation

class Track {
    
    // MARK: - Constants
    let artist: String
    let index: Int
    let name: String
    let previewURL: URL
    
    // MARK: - Variables & Properties
    var downloaded = false
    
    // MARK: - Initialization
    init(name: String, artist: String, previewURL: URL, index: Int) {
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
    }
}
