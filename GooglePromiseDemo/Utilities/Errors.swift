//
//  Errors.swift
//  ast-v2
//
//  Created by James Hall on 6/17/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import Foundation

enum BaseClientError : Error {
    case unableToCreateUrlRequest(message: String)
}

enum VinRequestError : Error {
    case missingVin(message: String)
    case missingUrl(message: String)
}
