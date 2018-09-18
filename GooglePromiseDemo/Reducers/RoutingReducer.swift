//
//  RoutingReducer.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 9/13/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import ReSwift

func routingReducer(action: Action, state: RoutingState?) -> RoutingState {
    var state = state ?? RoutingState()
    
    switch (action) {
        
    case let routingAction as RoutingAction:
        state.navigationState = routingAction.destination
    
    default:
        break
    } 
    
    return state
}
