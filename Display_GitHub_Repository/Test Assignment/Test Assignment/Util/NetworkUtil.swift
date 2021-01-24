//
//  NetworkUtil.swift
//  Test Assignment
//
//  Created by Johannes Grün on 24.01.21.
//

import Foundation

typealias RepositoryRequestCompletion = (_ repository: [Repository]) -> Void
typealias CommitRequestCompletion = (_ repository: [Commits]) -> Void

final class NetworkUtil {
    static let shared = NetworkUtil()

    private init() { }
    
    /// Makes a URL Request to fetch all repositories
    /// - Parameters:
    ///   - url: GitHub users URL
    ///   - completion: completion block
    func fetchRepository(url: URL, completion: @escaping RepositoryRequestCompletion) {
        let urlRequest = URLRequest(url: url)

        // Send the repository request off
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Repository].self, from: data) {
                    // Make sure we dispatch the following in the main thread
                    DispatchQueue.main.async {
                        // Call upon completion the callback
                        completion(decodedResponse)
                    }

                    return
                }
            }

            print("Request Failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    /// Makes a URL Request to fetch all available commits per Repository
    /// - Parameters:
    ///   - url: GitHub Repository URL
    ///   - completion: completion block
    func fetchCommit(with url: URL, completion: @escaping CommitRequestCompletion) {
        let urlRequest = URLRequest(url: url)
        
        // Send the repository request off
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Commits].self, from: data) {
                    // Make sure we dispatch the following in the main thread
                    DispatchQueue.main.async {
                        // Call upon completion the callback
                        completion(decodedResponse)
                    }

                    return
                }
            }

            print("Request Failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}
