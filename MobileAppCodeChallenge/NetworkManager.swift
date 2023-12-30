//
//  NetworkManager.swift
//  MobileAppCodeChallenge
//
//  Created by Sanjay Mali on 30/12/23.
//

import Foundation
struct ImgurAPI {
    static func searchImages<T: Decodable>(query: String, sort: String, window: String, page: Int) async throws -> T {
        var urlComponents = URLComponents(string: API.baseURL + "\(sort)/\(window)/\(page)")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]

        guard let url = urlComponents.url else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Client-ID \(Constants.clientID)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
}
