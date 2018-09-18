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
import Kingfisher

class RonSwansonServiceClient {
    
    static var singleSwansonQuoteUrl = "http://ron-swanson-quotes.herokuapp.com/v2/quotes"
    
    /// Array of Ron Swanson image urls
    static var swansonImages = [#imageLiteral(resourceName: "ron-swanson-1"), #imageLiteral(resourceName: "ron-swanson-2"), #imageLiteral(resourceName: "ron-swanson-3"), #imageLiteral(resourceName: "ron-swanson-4"), #imageLiteral(resourceName: "ron-swanson-5")]
    
    static func getSingleSwasonQuote() -> Promise<String> {
        
        /// Promises use the main dispatch queue by default
        return Promise () { fulfill, reject in
            
            let request = self.createUrlRequest(url: self.singleSwansonQuoteUrl)
            
            URLSession.shared.dataTask(with: request) {(data, response, error) in
                
                guard error == nil else {
                    reject(error!)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let quoteResponse = try JSONDecoder().decode([String].self, from: data)
                    fulfill(quoteResponse[0])
                } catch let error {
                    reject(error)
                }
            }.resume()
        }
    }

    static func createUrlRequest(url: String?) -> URLRequest {
        var request = URLRequest(url: URL(string: url ?? "")!)
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}

// MARK: - UIButton Extensions
extension UIButton {
    
    /// Retrieves a Ron Swanson image from a pseudo-randomly chosen image URL,
    /// and assigns it to the button's background image
    func getSingleSwansonImage() {
        
        let swansonImages = RonSwansonServiceClient.swansonImages
        let randomIndex = Int(arc4random_uniform(UInt32(swansonImages.count)))
        
        let image = swansonImages[randomIndex]
        
        self.setBackgroundImage(image, for: .normal)
    }
    
    /// Retrieves a Ron Swanson image from a pseudo-randomly chosen image URL,
    /// and assigns it to the button's background image with a nifty little transition
    func getSingleSwansonImageWithTransition() {
        
        let swansonImages = RonSwansonServiceClient.swansonImages
        let randomIndex = Int(arc4random_uniform(UInt32(swansonImages.count)))
        
        let image = swansonImages[randomIndex]
        
        UIView.transition(with: self,
                          duration: 1.0,
                          options: .transitionCurlUp,
                          animations: { self.setBackgroundImage(image, for: .normal)},
                          completion: nil)
    }
    
    // Similar to getSingleSwansonImageWithTransition, however image is passed-in
    // rather-than being retrieved by the extension method itself
    func setSwansonImageWithTransition(swansonImage: UIImage?) {
        
        if let swansonImage = swansonImage {
            UIView.transition(with: self,
                              duration: 1.0,
                              options: .transitionCurlUp,
                              animations: { self.setBackgroundImage(swansonImage, for: .normal)},
                              completion: nil)
        }
    }
    
    // Adds a simple shadow to the UIButton
    func addShadow() {
        
        // Adjust button shadow color, offset, radius, & opacity
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1.0
    }
}

//MARK: - UIImageExtensions
extension UIImage {
    
    // Enum of all of the Ron Swanson images that are in the Assets collection
    // for use with the UIImage convenience initializer
    enum SwansonImage: String {
        case swanson1 = "ron-swanson-1"
        case swanson2 = "ron-swanson-2"
        case swanson3 = "ron-swanson-3"
        case swanson4 = "ron-swanson-4"
        case swanson5 = "ron-swanson-5"
        
        static let values = [#imageLiteral(resourceName: "ron-swanson-1"), #imageLiteral(resourceName: "ron-swanson-2"), #imageLiteral(resourceName: "ron-swanson-3"), #imageLiteral(resourceName: "ron-swanson-4"), #imageLiteral(resourceName: "ron-swanson-5")]
    }
    
    // Returns a pseudo-random SwansonImage enum value
    static func randomSwansonImage() -> SwansonImage {
        
        let swansonImages: [SwansonImage] = [.swanson1,
                                             .swanson2,
                                             .swanson3,
                                             .swanson4,
                                             .swanson5]
        
        let randomIndex = Int(arc4random()) % swansonImages.count
        
        return swansonImages[randomIndex]
    }
    
    convenience init(swansonImage: SwansonImage) {
        self.init(named: swansonImage.rawValue)!
    }
}

//MARK: - UIView Extensions
extension UIView {
    
    func fadeInPromise() -> Promise<Bool> {
        return wrap { handler in
            self.fadeIn(completion: handler)
        }
    }
    
    func fadeOutPromise() -> Promise<Bool> {
        return wrap { handler in
            self.fadeOut(completion: handler)
        }
    }
    
    func fadeIn(_ duration: TimeInterval = 2.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 2.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}