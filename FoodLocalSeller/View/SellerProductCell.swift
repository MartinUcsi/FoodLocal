//
//  SellerProductCell.swift
//  FoodLocalSeller
//
//  Created by Martin Parker on 13/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Kingfisher



class SellerProductCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    //Variable
   
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configureCell(product: Product) {
        
        self.product = product
        
        
        productTitle.text = product.name
        //productPrice.text = String(product.price)
        
        if let url = URL(string: product.imageUrl){
                   productImg.kf.indicatorType = .activity
                   productImg.kf.setImage(with: url)
               }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber){
            productPrice.text = price
        }
        
      
        
    }
    
}
