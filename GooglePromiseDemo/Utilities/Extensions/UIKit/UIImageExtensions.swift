//
//  UIImageExtensions.swift
//
//  Created by James Hall on 9/13/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import UIKit

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
