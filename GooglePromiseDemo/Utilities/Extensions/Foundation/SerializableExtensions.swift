//
//  SerializableExtensions.swift
//  ast-v2
//
//  Created by James Hall on 6/13/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import Foundation

protocol Serializable : Codable {
    func serialize() -> Data?
}

extension Serializable {
    
    func serialize() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
