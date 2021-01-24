//
//  Owner.swift
//  Test Assignment
//
//  Created by Johannes Grün on 24.01.21.
//

import Foundation

class Owner: Codable {
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "login"
    }
}
