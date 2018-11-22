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
    
    var state = state ?? SwansonState(
        quoteText: "Never half-ass two things. Whole-ass one thing.",
        swansonImage: UIImage(named: "ron-swanson-1")!
    )
    
    switch(action) {
        
    case let action as GetSingleSwansonQuoteAction:
        state = setSingleQuoteAndImage(
            action: action,
            state: state
        )
    default:
        break
    }
    
    return state
}

func setSingleQuoteAndImage(action: GetSingleSwansonQuoteAction, state: SwansonState) -> SwansonState {
    
    var state = state
    state.swansonImage = action.swansonImage
    state.quoteText = action.swansonQuote
    return state
}
