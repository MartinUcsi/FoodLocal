//
//  ViewController.swift
//  ArtableAdmin
//
//  Created by Martin Parker on 09/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.leftBarButtonItem?.isEnabled = false
        
        let addCategoryBtn = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryBtn
    }


    @objc func addCategory(){
        //Segues to the add category view
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
        
    }
}

