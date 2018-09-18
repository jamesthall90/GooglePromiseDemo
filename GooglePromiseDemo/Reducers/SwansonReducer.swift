//
//  SwansonReducer.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 9/13/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import ReSwift
import UIKit

func swansonReducer(action: Action, state: SwansonState?) -> SwansonState {
    
    var state = state ?? SwansonState(quoteText: "Never half-ass two things. Whole-ass one thing.", swansonImage: UIImage(named: "ron-swanson-1")!)
    
    switch(action) {
        
    case _ as GetSingleSwansonQuoteAction:
            state = SwansonState(quoteText: "You had me at meat tornado.", swansonImage: UIImage(named: "ron-swanson-2"))
        
    default:
        break
    }
    
    return state
}
