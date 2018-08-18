//
//  ViewController.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 8/7/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import UIKit
import Promises

class SwansonViewController: UIViewController {

    @IBOutlet weak var swanSon: UIButton?
    @IBOutlet weak var quoteTextView: UITextView?
    var swansonClient: RonSwansonServiceClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swansonClient = RonSwansonServiceClient()
        
        formatButton(button: swanSon)
        
        generateNewSwansonQuoteWithImage()
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
       
        generateNewSwansonQuoteWithImageAndTransition()
    }
}

