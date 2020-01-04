//
//  CartItemCell.swift
//  Artable
//
//  Created by Martin Parker on 02/01/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

protocol CartItemDelegate : class {
    func removeItem(product: Product)
}

class CartItemCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    //Variable
    private var item: Product!
    weak var delegate : CartItemDelegate?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product : Product, delegate: CartItemDelegate){
        self.delegate = delegate
        self.item = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitleLbl.text = product.name
            productPriceLbl.text = price
        }
        if let url = URL(string: product.imageUrl) {
            productImg.kf.setImage(with: url)
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
        delegate?.removeItem(product: item)
    }
    
    
}
