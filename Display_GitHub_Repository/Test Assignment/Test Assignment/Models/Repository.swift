//
//  Repository.swift
//  Test Assignment
//
//  Created by Johannes Grün on 24.01.21.
//

import Foundation

class Repository: Codable {
    let name: String?
    let url: String?
    let description: String?
    let owner: Owner?
    let forks: Int?
    let watchers: Int?
    let language: String?

    var commits: Commits?

    // Use CodingKeys for understandable internal names
    private enum CodingKeys: String, CodingKey {
        case name, description, language, owner
        case url = "html_url"
        case forks = "forks_count"
        case watchers = "watchers_count"
    }
}
