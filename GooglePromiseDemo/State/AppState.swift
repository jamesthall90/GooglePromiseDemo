//
//  AppState.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 9/13/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import Foundation
import ReSwift

struct AppState : StateType {
    let routingState: RoutingState
    let swansonState: SwansonState
}
