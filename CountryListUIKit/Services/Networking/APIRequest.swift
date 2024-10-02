//
//  APIRequest.swift
//  CountryListUIKit
//
//  Created by Abouzar Moradian on 10/2/24.
//

import Foundation

protocol APIRequest {
    
    
    
    static var acceptableStatusCode: Set<Int> {get}

    var method: String {get}
    var host: String {get}
    var path: String {get}
    var body: Data? {get}
    var queryItems: [URLQueryItem] {set get}
    
}

extension APIRequest {

    var host: String {Constants.host.rawValue}
    var path: String {Constants.countryPath.rawValue}
    var method: String {return "GET" }
    var body: Data? { return nil }
    var queryItems: [URLQueryItem] {return []}
    static var acceptableStatusCode: Set<Int> {return Set([200])}
    
}

extension APIRequest {
    
    func with(queryItems: [URLQueryItem]) -> Result<URLRequest, Error> {
        
        guard let escapedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return Result.failure(APIRequestError.pathEncodingFailed(path))
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.percentEncodedPath =  escapedPath
        //components.queryItems = queryItems
        
//        guard let requestUrl = components.url else {
//            return Result.failure(APIRequestError.urlBuildFailed)
//        }
        guard let requestUrl = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json") else {
            return Result.failure(APIRequestError.urlBuildFailed)
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method
        request.httpBody = body
        
        return Result.success(request)
    }
}

class CountryAPIRequest: APIRequest{
    var queryItems = [URLQueryItem]()
    
}



enum APIRequestError: Error, LocalizedError{
    
    case pathEncodingFailed(String), urlBuildFailed
    
    var errorDescription: String? {
        switch self {
        case .pathEncodingFailed(let path):
            return "Failed to add percent escapes to path \(path)"
        case .urlBuildFailed:
            return "Failed to build url"
        }
    }
}



