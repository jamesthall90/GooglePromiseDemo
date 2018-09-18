//
//  RoutingState.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 9/13/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import ReSwift

struct RoutingState: StateType {
    
    var navigationState: RoutingDestination
    
    init(navigationState: RoutingDestination = .swanson) {
        self.navigationState = navigationState
    }
}
