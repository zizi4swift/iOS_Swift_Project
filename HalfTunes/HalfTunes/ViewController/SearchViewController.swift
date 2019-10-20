//
//  SearchViewController.swift
//  HalfTunes
//
//  Created by setsu on 2019/10/20.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit

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
    
    // MARK: - View Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    /// キーボードを隠すメソッド
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
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
        
        // TODO: - 検索結果を取得する機能実装
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        view.removeGestureRecognizer(tapRecognizer)
    }
}

