//
//  OrderDetailVC.swift
//  FoodLocalAdmin
//
//  Created by Martin Parker on 04/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController {

    //Outlets

    
//    @IBOutlet weak var itemArrayLbl: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var itemArrayLbl: UITextView!
    @IBOutlet weak var customerAddress: UITextView!
    
    @IBOutlet weak var completeBtn: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    //Variable
    var order: Order!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var addressArray = ""
        var itemArray = ""
        
        for i in order.item{
            itemArray.append("\(i) \n")
           
        }
        
        itemArrayLbl.text = itemArray
        addressArray.append("\(order.lineOne) \n")
        addressArray.append("\(order.lineTwo)")
        
        customerAddress.text = addressArray

//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissOrder))
//        tap.numberOfTapsRequired = 1
//        bgView.addGestureRecognizer(tap)
//    }
//    @objc func dismissOrder(){
//           dismiss(animated: true, completion: nil)
//    }
//
    
}
    //Action
    
    @IBAction func completeClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
