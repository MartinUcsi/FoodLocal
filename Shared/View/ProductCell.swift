 //
//  ProductCell.swift
//  Artable
//
//  Created by Martin Parker on 16/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Kingfisher
 
 protocol ProductCellDelegate : class {
    func productFavorited(product: Product)
    func productAddToCart(product: Product)
 }
 
class ProductCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    weak var delegate : ProductCellDelegate?
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product, delegate: ProductCellDelegate) {
        
        self.product = product
        self.delegate = delegate
        
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
        
        if UserService.favorites.contains(product) {
            favoriteBtn.setImage(UIImage(named: AppImage.FilledStar), for: .normal)
        }else{
            favoriteBtn.setImage(UIImage(named: AppImage.EmptyStar), for: .normal)
        }
    
        
    }
    
    //Action
    @IBAction func addToCartClicked(_ sender: UIButton) {
//        StripeCart.addItemToCart(item: product)
        
        delegate?.productAddToCart(product: product)
        
    }
    
    
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product )
    }
    
    
    
}
