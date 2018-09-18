//
//  ViewController.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 8/7/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import UIKit
import Promises
import ReSwift

class SwansonViewController: UIViewController {

    @IBOutlet weak var swanSon: UIButton?
    @IBOutlet weak var quoteTextView: UITextView?
    var swansonClient: RonSwansonServiceClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swansonClient = RonSwansonServiceClient()
        
        swanSon?.addShadow()
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
    
    
    /// Generates a new Ron Swanson quote & image
    /// and assigns them to a text view and
    /// button background image, respectively
    fileprivate func generateNewSwansonQuoteWithImage() {
        
        RonSwansonServiceClient.getSingleSwasonQuote().then { quote in

            self.quoteTextView?.text = "\"\(quote)\""

            self.swanSon?.getSingleSwansonImage()
        }
    }
    
    /// Generates a new Ron Swanson quote & image
    /// and assigns them to a text view and
    /// button background image, respectively with a transition between images
    fileprivate func generateNewSwansonQuoteWithImageAndTransition() {

        RonSwansonServiceClient.getSingleSwasonQuote().then { quote in
            
            self.quoteTextView?.text = "\"\(quote)\""
            
            self.swanSon?.getSingleSwansonImageWithTransition()
        }
    }
    
    @IBAction func swansonButtonTapped(_ sender: Any) {
       
        // Should probably call some sort of middleware to handle Promise
        store.dispatch(GetSingleSwansonQuoteAction())
    }
}

// MARK: - StoreSubscriber
extension SwansonViewController: StoreSubscriber {
    func newState(state: SwansonState) {
        
        self.quoteTextView?.text = "\"\(state.quoteText ?? "")\""
        
        self.swanSon?.setSwansonImageWithTransition(swansonImage: state.swansonImage)
    }
}

