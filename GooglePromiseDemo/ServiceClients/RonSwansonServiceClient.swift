//
//  RonSwansonServiceClient.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 8/7/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import Foundation
import UIKit
import Promises

class RonSwansonServiceClient {
    
    /// Array of Ron Swanson image urls
    static var swansonImages = [#imageLiteral(resourceName: "ron-swanson-1"), #imageLiteral(resourceName: "ron-swanson-2"), #imageLiteral(resourceName: "ron-swanson-3"), #imageLiteral(resourceName: "ron-swanson-4"), #imageLiteral(resourceName: "ron-swanson-5"), #imageLiteral(resourceName: "ron-swanson-6")]
    
    // Retrieves a single Ron Swanson Quote
    static func getSingleSwasonQuote() -> Promise<String> {
        
        /// Promises use the main dispatch queue by default
        return Promise() { fulfill, reject in
            
            let request = try generateSwansonQuoteUrlRequest(query: "")
            
            URLSession.shared.dataTask(with: request) {data, response, error in
                
                // If an error exists, reject the promise
                guard error == nil else {
                    reject(error!)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    // Deserialize the quote, which is returned from the API as an array
                    let quoteResponse = try JSONDecoder().decode([String].self, from: data)
                    
                    // Fulfill the promise just the first array element,
                    // as there is only one quote in the array
                    fulfill(quoteResponse[0])
                    
                } catch let error {
                    // If an error exists, reject the promise
                    reject(error)
                }
            }.resume()
        }
    }
    
    //Retrieves a collection of Ron Swanson quotes, whose count is specified by the input parameter
    static func getMultipleQuotes(retrieveCount: Int) -> Promise<[String]>{
        
        return Promise() { fulfill, reject in
            
            let request = try generateSwansonQuoteUrlRequest(
                query: String(retrieveCount)
            )
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                // If an error exists, reject the promise
                guard error == nil else {
                    reject(error!)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    // Deserialize the quote collection
                    let quoteCollection = try JSONDecoder().decode([String].self, from: data)
                    
                    // Fulfill the promise with the quote collection
                    fulfill(quoteCollection)
                    
                } catch let error {
                    // If an error exists, reject the promise
                    reject(error)
                }
            }.resume()
        }
    }
    
    static func generateSwansonQuoteUrlRequest(query: String?) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "ron-swanson-quotes.herokuapp.com"
        components.path = "/v2/quotes/"
        components.queryItems = [
            URLQueryItem(name: "", value: query ?? "")
        ]

        var request = try URLRequest(
            url: components.url
                .orThrow(UrlError.urlWasNil)
        )
        
        request.httpMethod = "GET"
        request.addValue(
            "application/json; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        return request
    }
}
