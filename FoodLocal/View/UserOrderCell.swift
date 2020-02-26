//
//  UserOrderCell.swift
//  FoodLocal
//
//  Created by Martin Parker on 22/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase

class UserOrderCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var orderidTxt: UILabel!
    @IBOutlet weak var orderTimeTxt: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var estimateTimeTxt: UILabel!
    @IBOutlet weak var statusPicImg: RoundedGrayImageView!
    @IBOutlet weak var callRiderBtn: RoundedButton!
    
    
    //Variable
    private var order: Order!
    var imageNo : Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configureCell(order: Order){
        
        imageNo = order.statusPic
        if imageNo == 1 {
            statusPicImg.image = UIImage(named: AppImage.orderReceived)
        }else if imageNo == 2{
            statusPicImg.image = UIImage(named: AppImage.orderAccept)
        }else if imageNo == 3{
            statusPicImg.image = UIImage(named: AppImage.riderReach)
        }else if imageNo == 4{
            statusPicImg.image = UIImage(named: AppImage.riderQueue)
        }else if imageNo == 5{
            statusPicImg.image = UIImage(named: AppImage.riderOtw)
        }else if imageNo == 6{
            statusPicImg.image = UIImage(named: AppImage.orderCompleted)
        }else{
            statusPicImg.image = UIImage(named: AppImage.orderReceived)
        }
        
        
        
         orderidTxt.text = "OrderID#\(order.id)"
        orderStatus.text = "Status: \(order.status)"
        estimateTimeTxt.text = "Estimate time:\(order.estimateTime) min left"
        
            //Show order time
            let OrderTime = order.timeStamp
          
           let aDate = OrderTime.dateValue()
           let formatter2 = DateFormatter()
           formatter2.locale = Locale(identifier: "en_US_POSIX")
          // formatter2.dateFormat = "HH:mm '-' dd/MM/yyyy"
           formatter2.dateFormat = "d MMM yyyy 'at' h:mm a"
           let formattedTimeZoneStr = formatter2.string(from: aDate)
           //print(formattedTimeZoneStr)
        
           orderTimeTxt.text = "Order Time: \(formattedTimeZoneStr)"
                  
        
        //Show estimate time
        if order.estimateTime == 0{
            estimateTimeTxt.text = ""
            callRiderBtn.isHidden = true
        }else{
            estimateTimeTxt.text = "Estimate time: \(order.estimateTime) min left"
            callRiderBtn.isHidden = false
        }
        
    }
    
    
    @IBAction func contactClicked(_ sender: UIButton) {
        
    }
    @IBAction func callRiderClicked(_ sender: UIButton) {
        
    }
    
}
