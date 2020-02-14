//
//  SellerCell.swift
//  FoodLocalSeller
//
//  Created by Martin Parker on 12/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Kingfisher
class SellerCell: UICollectionViewCell {

    @IBOutlet weak var sellerImg: UIImageView!
    @IBOutlet weak var sellerLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sellerImg.layer.cornerRadius = 5
        
    }

    func configureCell(category: Category){
        sellerLbl.text = category.name
        if let url = URL(string: category.imgUrl){
            // put a background image before category image loaded up
            
            //let placeholder = UIImage(named: "foodstall_Placeholder")
           // categoryImg.kf.setImage(with: url, placeholder: placeholder, options: options)
           // let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            // put the activity indicator while loading the category image
            sellerImg.kf.indicatorType = .activity
            sellerImg.kf.setImage(with: url)
        }
    }
}
