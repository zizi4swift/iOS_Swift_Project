//
//  TrackCell.swift
//  HalfTunes
//
//  Created by setsu on 2019/10/20.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit

// MARK: - Track Cell Delegate Protocol
protocol TrackCellDelegate {
    /// キャンセル
    func cancelTapped(_ cell:TrackCell)
    /// ダウンロード
    func downloadTapped(_ cell: TrackCell)
    /// 止める
    func pauseTapped(_ cell: TrackCell)
    /// 続行する
    func resumeTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {
    
    // MARK: - Class Constants
    static let identifier = "TrackCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    // MARK: - Variables & Properties
    var delegate: TrackCellDelegate?
    
    // MARK: - IBAction
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate?.cancelTapped(self)
    }
    
    @IBAction func pauseOrResumeButtonTapped(_ sender: UIButton) {
        if pauseButton.titleLabel?.text == "Pause" {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        delegate?.downloadTapped(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Internal Methods
    
    /// セルを配置するメソッド
    /// - Parameter track: 曲クラス
    /// - Parameter downloaded: ダウンロード完了したかどうかを判断するBool
    /// - Parameter download: ダウンロード関連情報クラス
    func configure(track: Track, downloaded: Bool, download: Download?) {
        titleLabel.text = track.name
        artistLabel.text = track.artist
        
        var showDownloadControls = false
        
        if let download = download {
            showDownloadControls = true
            
            let title = download.isDownloading ? "Pause" : "Resume"
            pauseButton.setTitle(title, for: .normal)
            
            progressLabel.text = download.isDownloading ? "Downloading" : "Paused"
        }
        
        pauseButton.isHidden = !showDownloadControls
        cancelButton.isHidden = !showDownloadControls
        
        progressView.isHidden = !showDownloadControls
        progressLabel.isHidden = !showDownloadControls
        
        selectionStyle = downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none
        downloadButton.isHidden = downloaded || showDownloadControls
    }
    
    
}
