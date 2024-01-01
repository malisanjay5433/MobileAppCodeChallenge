//
//  NetworkManager.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import Foundation
struct NetworkManager {
    
    // Shared URLSession and JSONDecoder for reuse
    private static let urlSession = URLSession.shared
    private static let jsonDecoder = JSONDecoder()
    /// Asynchronously searches for the top images of the week from Imgur gallery.
    /// - Parameters:
    ///   - query: The search query string.
    ///   - sort: The sort criteria for the search.
    ///   - window: The time window for the search.
    ///   - urlSession: The URLSession to use for the network request. Defaults to shared URLSession.
    ///   - jsonDecoder: The JSONDecoder to use for decoding the response. Defaults to shared JSONDecoder.
    /// - Returns: A generic type conforming to Decodable representing the search result.
    /// - Throws: An ImgurAPIError in case of invalid URL or a failed network request.
    static func request<T: Decodable>(
        query: String,
        sort: String,
        window: String,
        urlSession: URLSession = NetworkManager.urlSession,
        jsonDecoder: JSONDecoder = NetworkManager.jsonDecoder
    ) async throws -> T {
        var urlComponents = URLComponents(string: API.baseURL )!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sort),
            URLQueryItem(name: "window", value: window)
        ]
        print("URL : \(urlComponents)")
        guard let url = urlComponents.url else {
            throw ImgurAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Client-ID \(AppConstants.clientID)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await urlSession.data(for: request)
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw ImgurAPIError.requestFailed(error)
        }
    }
}

/// Enum representing errors specific to Imgur API interactions.
enum ImgurAPIError: Error {
    case invalidURL
    case requestFailed(Error)
}
