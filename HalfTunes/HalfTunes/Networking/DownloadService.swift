//
//  DownloadService.swift
//  HalfTunes
//
//  Created by setsu on 2019/10/27.
//  Copyright © 2019 setsu. All rights reserved.
//

import Foundation

/// ネットワークラッパークラス
class DownloadService {
    
    // MARK: - Variables & Properties
    var activeDownloads: [URL: Download] = [ : ]
    
    var downloadSession: URLSession!
    
    // MARK: - Internal Methods
    
    /// ダウンロードをキャンセルするメソッド
    /// - Parameter track: 曲クラス
    func cancelDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else {
            return
        }
        
        download.task?.cancel()
        activeDownloads[track.previewURL] = nil
    }
    
    /// ダウンロードを一時停止するメソッド
    /// - Parameter track: 曲クラス
    func pauseDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL],
            download.isDownloading else {
                return
        }
        
        download.task?.cancel(byProducingResumeData: { (data) in
            download.resumeData = data
        })
        download.isDownloading = false
    }
    
    /// ダウンロードを継続するメソッド
    /// - Parameter track: 曲
    func resumeDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else { return }
        
        if let resumeData = download.resumeData {
            download.task = downloadSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadSession.downloadTask(with: download.track.previewURL)
        }
        
        download.task?.resume()
        download.isDownloading = true
    }
    
    /// ダウンロードを開始するメソッド
    /// - Parameter track: 曲クラス
    func startDownload(_ track: Track) {
        let download = Download(track: track)
        download.task = downloadSession.downloadTask(with: track.previewURL)
        download.task?.resume()
        
        download.isDownloading = true
        activeDownloads[download.track.previewURL] = download
    }
}
