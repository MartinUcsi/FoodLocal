//
//  PaymentInstructionVC.swift
//  FoodLocal
//
//  Created by Martin Parker on 21/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

class PaymentInstructionVC: UIViewController {

    //Outlet
    @IBOutlet weak var paymentImg: UIImageView!
    @IBOutlet weak var reminderLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    
    //Variable
    var paymentImageNo : Int = 0
    var reminderNotice : String = ""
    var DetailNotice : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if paymentImageNo == 1 {
            paymentImg.image = UIImage(named: AppImage.touchngoDetail)
        }else if paymentImageNo == 2 {
            paymentImg.image = UIImage(named: AppImage.maybankDetail)
        }else if paymentImageNo == 3 {
            paymentImg.image = UIImage(named: AppImage.grabpayDetail)
        }else if paymentImageNo == 4{
            paymentImg.image = UIImage(named: AppImage.boostDetail)
        }else if paymentImageNo == 5{
            paymentImg.image = UIImage(named: AppImage.alipayDetail)
        }else{
            paymentImg.image = UIImage(named: AppImage.GreenCheck)
        }
        
       
            reminderLbl.text = reminderNotice
            detailLbl.text = DetailNotice
        
    }

    @IBAction func okClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
