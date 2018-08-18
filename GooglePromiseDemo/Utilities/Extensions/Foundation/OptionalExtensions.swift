//
//  OptionalExtensions.swift
//  ast-v2
//
//  Created by James Hall on 6/17/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import Foundation

extension Optional {
    /// Unwraps `self` if it is non-`nil`.
    /// Throws the given error if `self` is `nil`.
    func or(error: Error) throws -> Wrapped {
        switch self {
        case let x?: return x
        case nil: throw error
        }
    }
}
