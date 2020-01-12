//
//  paymentMethodVC.swift
//  Artable
//
//  Created by Martin Parker on 12/01/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

class paymentMethodVC: UIViewController {

    
    // variable
    var paymentMethodTxt = ""
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
//Action
    
  
    @IBAction func touchNGoClicked(_ sender: Any) {
        self.paymentMethodTxt = "TouchNGo"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)
    }
    
    @IBAction func maybankClicked(_ sender: Any) {
        self.paymentMethodTxt = "MaybankQR"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)
    }

    @IBAction func grabPayClicked(_ sender: Any) {
        self.paymentMethodTxt = "GrabPay"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)
    }
    
    
    @IBAction func cashClicked(_ sender: Any) {
        self.paymentMethodTxt = "Cash"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)
    }
    
    @IBAction func boostClicked(_ sender: Any) {
        self.paymentMethodTxt = "Boost"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)
    }
    
    
    @IBAction func alipayClicked(_ sender: Any) {
        self.paymentMethodTxt = "Alipay"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! CheckoutVC
        vc.selectedPaymentMethod = self.paymentMethodTxt
    }
    

}
