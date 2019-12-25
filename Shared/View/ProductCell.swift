 //
//  ProductCell.swift
//  Artable
//
//  Created by Martin Parker on 16/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Kingfisher
 
class ProductCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product) {
        
        productTitle.text = product.name
        productPrice.text = String(product.price)
        
        if let url = URL(string: product.imageUrl){
                   productImg.kf.indicatorType = .activity
                   productImg.kf.setImage(with: url)
               }
        
        
    }
    
    //Action
    @IBAction func addToCartClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func favoriteClicked(_ sender: Any) {
    }
    
    
    
}
