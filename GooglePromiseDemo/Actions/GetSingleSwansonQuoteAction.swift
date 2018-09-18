//
//  GetSingleSwansonQuoteAction.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 9/13/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import ReSwift
import UIKit
import Promises

struct GetSingleSwansonQuoteAction : Action {
    var swansonQuote: String?
    var swansonImage: UIImage?
}

// Gets a Swanson quote and image from a remote API
// and then dispatches the appropriate action
func getSingleQuoteThunk() {
    
    RonSwansonServiceClient.getSingleSwasonQuote().then { quote in
        
        let quoteText = "\(quote)"
        
        store.dispatch(GetSingleSwansonQuoteAction(
            swansonQuote: quoteText,
            swansonImage: UIImage(
                swansonImage: UIImage.randomSwansonImage())
            )
        )
    }
}
