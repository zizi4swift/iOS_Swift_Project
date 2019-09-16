//
//  ImaggaRouter.swift
//  PhotoTagger
//
//  Created by setsu on 2019/09/16.
//  Copyright © 2019 setsu. All rights reserved.
//

import Foundation
import Alamofire


/// API通信周りルーター
public enum ImaggaRouter: URLRequestConvertible {
    
    /// 定数
    enum Constants {
        static let baseURLPath = "http://api.imagga.com/v1"
        // https://imagga.com/profile/dashboardで発行されたToken
        static let authenticationToken = "Basic YWNjXzQyN2YxNmQ3MWJlYmU0YToxYzY4YzM2NGVjMWEwOTg1ZDMzNzEzNDM5MDgzNmQzZA=="
    }
    
    case content
    case tags(String)
    case colors(String)
    
    /// メソッド
    var methods: HTTPMethod {
        switch self {
        case .content:
            return .post
        case .tags, .colors:
            return .get
        }
    }
    
    /// パス
    var path: String {
        switch self {
        case .content:
            return "/content"
        case .tags:
            return "/tagging"
        case .colors:
            return "/colors"
        }
    }
    
    /// パラメーター
    var parameters: [String: Any] {
        switch self {
        case .tags(let contentID):
            return ["content" : contentID]
        case .colors(let contentID):
            return ["content" : contentID, "extract_object_colors" : 0]
        default:
            return [:]
        }
    }
    
    /// URLリクエストに変換するメソッド
    ///
    /// - Returns: URLリクエストオブジェクト
    /// - Throws: エラー
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = methods.rawValue
        request.setValue(Constants.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
