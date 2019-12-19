//
//  CategoryCell.swift
//  Artable
//
//  Created by Martin Parker on 13/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Kingfisher
class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImg.layer.cornerRadius = 5
        
    }
    
    func configureCell(category: Category){
        categoryLbl.text = category.name
        if let url = URL(string: category.imgUrl){
            // put a background image before category image loaded up
            
            //let placeholder = UIImage(named: "foodstall_Placeholder")
           // categoryImg.kf.setImage(with: url, placeholder: placeholder, options: options)
           // let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            // put the activity indicator while loading the category image
            categoryImg.kf.indicatorType = .activity
            categoryImg.kf.setImage(with: url)
        }
    }

}
