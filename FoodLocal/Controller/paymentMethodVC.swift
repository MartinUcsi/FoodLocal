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
       // self.navigationController?.popViewController(animated: true)

        //Show paymentDetailVC
        let vc = PaymentInstructionVC()
        vc.paymentImageNo = 1
        vc.reminderNotice = "Friendly Reminder:"
        vc.DetailNotice = "Scan the QR code of the rider's TouchNGo apps to complete the payment. Make sure you have enough balance for the order."


        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)

        
    }
    
    @IBAction func maybankClicked(_ sender: Any) {
        
        
        self.paymentMethodTxt = "MaybankQR"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)

        //Show paymentDetailVC
        let vc = PaymentInstructionVC()
        vc.paymentImageNo = 2
        vc.reminderNotice = "Friendly Reminder:"
        vc.DetailNotice = "Scan the QR code of the rider's Maybank MY apps to complete the payment. Make sure you have enough balance for the order."


        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }

    @IBAction func grabPayClicked(_ sender: Any) {
        
        
        
        self.paymentMethodTxt = "GrabPay"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)


        //Show paymentDetailVC
        let vc = PaymentInstructionVC()
        vc.paymentImageNo = 3
        vc.reminderNotice = "Friendly Reminder:"
        vc.DetailNotice = "Scan the QR code of the rider's Grab apps to complete the payment. Make sure you have enough balance for the order."


        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func cashClicked(_ sender: Any) {
        
        
        
        self.paymentMethodTxt = "Cash"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)
    }
    
    @IBAction func boostClicked(_ sender: Any) {
        
        
        
        self.paymentMethodTxt = "Boost"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)

        //Show paymentDetailVC
        let vc = PaymentInstructionVC()
        vc.paymentImageNo = 4
        vc.reminderNotice = "Friendly Reminder:"
        vc.DetailNotice = "Scan the QR code of the rider's Boost apps to complete the payment. Make sure you have enough balance for the order."


        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func alipayClicked(_ sender: Any) {
        
        
        
        self.paymentMethodTxt = "Alipay"
        performSegue(withIdentifier: Identifiers.backToCheckout, sender: self)

        //Show paymentDetailVC
               let vc = PaymentInstructionVC()
               vc.paymentImageNo = 5
               vc.reminderNotice = "Friendly Reminder:"
               vc.DetailNotice = "Scan the QR code of the rider's Alipay apps to complete the payment. Make sure you have enough balance for the order."


               vc.modalTransitionStyle = .coverVertical
               vc.modalPresentationStyle = .overCurrentContext
               present(vc, animated: false, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! CheckoutVC
        vc.selectedPaymentMethod = self.paymentMethodTxt
    }
    

}
