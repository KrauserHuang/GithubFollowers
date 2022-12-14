//
//  NetworkManager.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/10/30.
//

import UIKit

class NetworkManager {
    static let shared   = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    var cache           = NSCache<NSString, UIImage>()
    let decoder         = JSONDecoder()
    
    private var baseGitHubUrl: URLComponents {
        var urlComponents           = URLComponents()
        urlComponents.scheme        = "https"
        urlComponents.host          = "api.github.com"
        urlComponents.path          = "/user/"
        urlComponents.queryItems    = [
            URLQueryItem(name: "username", value: ""),
            URLQueryItem(name: "page", value: "")
        ]
        return urlComponents
    }
    
    private init() {
        decoder.keyDecodingStrategy     = .convertFromSnakeCase
        decoder.dateDecodingStrategy    = .iso8601
    }
    //https://api.github.com/users/\(username)/followers?per_page=100&page=\(page)
//    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
//        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
//        Task {
//            fetchData(endpoint: endpoint)
//        }
//    }
//
//    func getUserInfo(for username: String) async throws -> User {
//        let endpoint = baseURL + "\(username)"
//        Task {
//            fetchData(endpoint: endpoint)
//        }
//    }
    
//    private func fetchData<T: Decodable>(endpoint: String) async throws -> T {
//        guard let url = URL(string: endpoint) else {
//            throw GFError.invalidUsername
//        }
//
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
//
//        let (data, response) = try await session.data(from: url)
//        //再處理 response
//        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
//            throw GFError.invalidResponse
//        }
//        //最後執行 decode
//        do {
//            return try decoder.decode(T.self, from: data)
//        } catch {
//            throw GFError.invalidData
//        }
//    }
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        fetchData(endpoint: endpoint, completion: completion)
    }

    func getUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseURL + "\(username)"
        fetchData(endpoint: endpoint, completion: completion)

    }
    
    private func fetchData<T: Decodable>(endpoint: String, completion: @escaping (Result<T, GFError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        let task = session.dataTask(with: url) { data, response, error in
            //先處理 error
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            //再處理 response
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            //再確認 data
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            //最後執行 decode
            do {
                let decoder                     = JSONDecoder()
                decoder.keyDecodingStrategy     = .convertFromSnakeCase
                decoder.dateDecodingStrategy    = .iso8601 //可將回傳的資料轉成這個Date顯示類型(所以資料型別要為Date)
                let a = try decoder.decode(T.self, from: data)
                completion(.success(a))
            } catch {
                completion(.failure(.invalidData))
            }
        }

        task.resume()
    }
    
    func downloadImage(for urlString: String, completion: @escaping (UIImage?) -> Void) {

        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
    
//    func downloadImage(for urlString: String) async -> UIImage? {
//
//        let cacheKey = NSString(string: urlString)
//        if let image = cache.object(forKey: cacheKey) { return image }
//        guard let url = URL(string: urlString) else { return nil }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            guard let image = UIImage(data: data) else { return nil }
//            self.cache.setObject(image, forKey: cacheKey)
//        } catch {
//            return nil
//        }
//    }
}
