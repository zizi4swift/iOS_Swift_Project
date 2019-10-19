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
    
    static let baseURLPath = "https://api.imagga.com/v2"
    // https://imagga.com/profile/dashboardで発行されたToken
    static let authenticationToken = "Basic YWNjXzQyN2YxNmQ3MWJlYmU0YToxYzY4YzM2NGVjMWEwOTg1ZDMzNzEzNDM5MDgzNmQzZA"
    
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
            return "/uploads"
        case .tags:
            return "/tags"
        case .colors:
            return "/colors"
        }
    }
    
    /// パラメーター
    
    
    /// URLリクエストに変換するメソッド
    ///
    /// - Returns: URLリクエストオブジェクト
    /// - Throws: エラー
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .tags(let uploadID):
                return ["image_upload_id" : uploadID]
            case .colors(let uploadID):
                return ["image_upload_id" : uploadID, "extract_object_colors" : 0]
            default:
                return [:]
            }
        }()
        
        
        let url = try ImaggaRouter.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = methods.rawValue
        request.setValue(ImaggaRouter.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
