//
//  AddEditProductsVC.swift
//  ArtableAdmin
//
//  Created by Martin Parker on 24/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit

class AddEditProductsVC: UIViewController {

    //Outlets
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImgView: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    
    //Variable
    var selectedCategory : Category!
    var productToEdit : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

   

}
