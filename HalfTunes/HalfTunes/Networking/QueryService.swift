//
//  QueryService.swift
//  HalfTunes
//
//  Created by setsu on 2019/10/20.
//  Copyright © 2019 setsu. All rights reserved.
//

import Foundation

class QueryService {
    
    // MARK: - Type Alias
    typealias JSONDictionary = [String : Any]
    typealias QueryResult = ([Track]?, String) -> Void
    
    // MARK: - Constants
    let defaultSession = URLSession(configuration: .default)
    
    // MARK: - Variales & Properties
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var tracks: [Track] = []
    
    // MARK: - Internal Methods
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            
            guard let url = urlComponents.url else {
                return
            }
            
            dataTask = defaultSession.dataTask(with: url, completionHandler: { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    // エラーの場合
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if
                    // リクエスト成功の場合
                  let data = data,
                  let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    self?.updataSearchResults(data)
                    
                    DispatchQueue.main.async {
                        completion(self?.tracks, self?.errorMessage ?? "")
                    }
                }
            })
            
            dataTask?.resume()
        }
    }
    
    // MARK: - Private Methods
    
    // 検索結果を更新するメソッド
    private func updataSearchResults(_ data: Data) {
        var response: JSONDictionary?
        tracks.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        
        var index = 0
        
        for trackDictionary in array {
            if let trackDictionary = trackDictionary as? JSONDictionary,
            let previewURLString = trackDictionary["previewUrl"] as? String,
                let previewURL = URL(string: previewURLString),
            let name = trackDictionary["trackName"] as? String,
                let artist = trackDictionary["artistName"] as? String {
                tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
                index += 1
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
}
