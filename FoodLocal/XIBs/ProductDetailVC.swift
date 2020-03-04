//
//  ProductDetailVC.swift
//  Artable
//
//  Created by Martin Parker on 20/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    //Outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    //Variable
    var product: Product!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productTitle.text = product.name
        productDescription.text = product.productDescription
        
        
        if let url = URL(string: product.imageUrl){
            productImg.kf.setImage(with: url)
            
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price =  formatter.string(from:  product.price as NSNumber){
            productPrice.text = price
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)

    }
    @objc func dismissProduct(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCartClicked(_ sender: Any) {
       
        StripeCart.addItemToCart(item: product)
        //dismiss(animated: true, completion: nil)
        presentAlert()
    }
    
    func presentAlert(){
        let alertController = UIAlertController(title: "Success", message: "Item Added To Cart Successfully! If you need two or more quantity of this item please click on the 'Add to cart' button again", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
           
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
