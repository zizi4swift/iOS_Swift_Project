//
//  Download.swift
//  HalfTunes
//
//  Created by setsu on 2019/10/25.
//  Copyright © 2019 setsu. All rights reserved.
//

import Foundation

/// ダウンロード関連クラス
class Download {
    // MARK: - Variables & Properties
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var track: Track
    
    // MARK: - INitialization
    init(track: Track) {
        self.track = track
    }
}
