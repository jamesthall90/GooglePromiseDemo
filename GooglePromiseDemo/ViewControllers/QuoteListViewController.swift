//
//  QuoteListViewController.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 9/26/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import UIKit
import ReSwift

class QuoteListViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var quoteListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) {
            $0.select {
                $0.swansonState
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
}

extension QuoteListViewController: StoreSubscriber {
    func newState(state: SwansonState) {
    }
}
