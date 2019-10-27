//
//  SearchViewController.swift
//  HalfTunes
//
//  Created by setsu on 2019/10/20.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit
import AVKit

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    // ジェスチャー認識コンポーネント
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    var searchResults: [Track] = []
    
    // MARK: - Constants
    let queryService = QueryService()
    let downloadService = DownloadService()
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    // MARK: - View Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    /// キーボードを隠すメソッド
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    /// TableViewの指定行をリフレッシュするメソッド
    /// - Parameter row: 指定された行
    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func localFilePath(for url: URL) -> URL? {
        guard let localFilePath = documentsPath?.appendingPathComponent(url.lastPathComponent) else { return nil }
        return localFilePath
    }
    
    func playDownload(_ track: Track) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        
        guard let url = localFilePath(for: track.previewURL) else { return }
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        // 検索バーに文字は存在するか及び空文字列ではないかを確認する
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        // インジケーターを表示する
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // 検索結果を取得する
        queryService.getSearchResults(searchTerm: searchText) { [weak self](results, errorMessage) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
            
            if let results = results {
                self?.searchResults = results
                // tableviewをリフレッシュする
                self?.tableView.reloadData()
                // tableviewの頂部まで表示する
                self?.tableView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        view.removeGestureRecognizer(tapRecognizer)
    }
}

// MARK: - TableView Data Source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TrackCell = tableView.dequeueReusableCell(withIdentifier: TrackCell.identifier, for: indexPath) as? TrackCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        let track = searchResults[indexPath.row]
        cell.configure(track: track,
                       downloaded: track.downloaded,
                       download: downloadService.activeDownloads[track.previewURL] )
        return cell
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = searchResults[indexPath.row]
        
        if track.downloaded {
            playDownload(track)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
}

// MARK: - Track Cell Delegate
extension SearchViewController: TrackCellDelegate {
    
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
    
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }
    
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
    }
    
}
