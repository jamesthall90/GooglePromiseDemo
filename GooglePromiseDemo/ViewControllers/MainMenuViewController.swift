//
//  MainMenuViewController.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 9/26/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import UIKit
import ReSwift

class MainMenuViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var getRandomButton: UIButton!
    @IBOutlet weak var quoteListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscibe the VC to the Store / Swanson State
        store.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe the VC from the Store / Swanson State upon disappearance
        store.unsubscribe(self)
    }
    
    func formatButtons() {
        
        // Add drop shadows to the buttons
        getRandomButton.addShadow()
        quoteListButton.addShadow()
    }
    
    @IBAction func openRandomQuoteView(_ sender: Any) {
        store.dispatch(
            RoutingAction(
                destination: .randomSwansonView
            )
        )
    }
    
    @IBAction func openQuoteListView(_ sender: Any) {
    }
}

extension MainMenuViewController: StoreSubscriber {
    func newState(state: RoutingState) { }
}
