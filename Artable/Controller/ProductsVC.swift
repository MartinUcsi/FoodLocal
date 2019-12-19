//
//  ProductsVC.swift
//  Artable
//
//  Created by Martin Parker on 16/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // Variables
    var products = [Product]()
    var category : Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let product = Product.init(name: "Black Tofu (黑豆腐)" , id: "jfjdf", category: "Nature", price: 24.66, productDescription: "haha very nice", imageUrl: "https://sedap.com.my/upload/file/image/IMG_4080.jpg", timeStampt: Timestamp() , stock: 0, favorite: false)
        products.append(product)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)

    }
    

}

extension ProductsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.row])
            return cell
            
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
     
}
