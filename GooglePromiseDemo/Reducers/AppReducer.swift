//
//  AppReducer.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 9/13/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        routingState: routingReducer(action: action, state: state?.routingState),
        swansonState: swansonReducer(action: action, state: state?.swansonState)
    )
}
