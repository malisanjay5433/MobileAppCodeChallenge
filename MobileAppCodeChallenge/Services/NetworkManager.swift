//
//  NetworkManager.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import Foundation
struct ImgurAPI {
    private static let urlSession = URLSession.shared
    private static let jsonDecoder = JSONDecoder()

    static func searchTopImageOfWeek<T: Decodable>(
        query: String,
        sort: String,
        window: String,
        urlSession: URLSession = ImgurAPI.urlSession,
        jsonDecoder: JSONDecoder = ImgurAPI.jsonDecoder
    ) async throws -> T {
        var urlComponents = URLComponents(string: API.baseURL + "\(sort)/\(window)")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]

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

enum ImgurAPIError: Error {
    case invalidURL
    case requestFailed(Error)
}
