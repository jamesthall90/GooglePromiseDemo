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
        
        formatButton(button: swanSon)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) {
            $0.select {
                $0.swansonState
            }
        }
        
        store.dispatch(RoutingAction(destination: .swanson))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    fileprivate func formatButton (button: UIButton!) {
        
        // Adjust button shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
    }
    
    
    /// Generates a new Ron Swanson quote & image
    /// and assigns them to a text view and
    /// button background image, respectively
    fileprivate func generateNewSwansonQuoteWithImage() {
        
        self.swansonClient?.getSingleSwasonQuote().then { quote in

            self.quoteTextView?.text = "\"\(quote)\""

            self.swanSon?.getSingleSwansonImage()
        }
    }
    
    /// Generates a new Ron Swanson quote & image
    /// and assigns them to a text view and
    /// button background image, respectively with a transition between images
    fileprivate func generateNewSwansonQuoteWithImageAndTransition() {

        self.swansonClient?.getSingleSwasonQuote().then { quote in
            
            self.quoteTextView?.text = "\"\(quote)\""
            
            self.swanSon?.getSingleSwansonImageWithTransition()
        }
    }
    
    @IBAction func swansonButtonTapped(_ sender: Any) {
       
        store.dispatch(GetSingleSwansonQuoteAction())
    }
}

// MARK: - StoreSubscriber
extension SwansonViewController: StoreSubscriber {
    func newState(state: SwansonState) {
        
        self.quoteTextView?.text = "\"\(state.quoteText ?? "")\""
        
        self.swanSon?.setImage(state.swansonImage, for: .normal)
    }
}

