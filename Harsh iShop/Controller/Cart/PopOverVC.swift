//
//  PopOverVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 24/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
protocol ProtocolPopOver : class {
    func editDelegateFunc(index : Int)
    func deleteDelegateFunc(index: Int)
}

class PopOverVC: UIViewController {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    
    var delegatePopOver : ProtocolPopOver? = nil
    
    var index : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegatePopOver?.editDelegateFunc(index: self.index!)
        }
    }
    
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        self.delegatePopOver?.deleteDelegateFunc(index: self.index!)
    }
    
}
