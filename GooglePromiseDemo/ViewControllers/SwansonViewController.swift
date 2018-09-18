//
//  ViewController.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 8/7/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import UIKit
import ReSwift

class SwansonViewController: UIViewController {

    @IBOutlet weak var swanSon: UIButton?
    @IBOutlet weak var quoteTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swanSon?.addShadow()
        
        getSingleQuoteThunk()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscibe the VC to the Store / Swanson State
        store.subscribe(self) {
            $0.select {
                $0.swansonState
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe the VC from the Store / Swanson State upon disappearance
        store.unsubscribe(self)
    }
    
    @IBAction func swansonButtonTapped(_ sender: Any) {
        
        // Calls a thunk which gets a Swanson quote and image,
        // and then dispatches the appropriate action
        getSingleQuoteThunk()
    }
}

// MARK: - StoreSubscriber
extension SwansonViewController: StoreSubscriber {
    func newState(state: SwansonState) {
        
        self.quoteTextView?.text = "\"\(state.quoteText ?? "")\""
        
        self.swanSon?.setSwansonImageWithTransition(swansonImage: state.swansonImage)
    }
}

