//
//  mainTabBar.swift
//  FoodLocalSeller
//
//  Created by Martin Parker on 10/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class mainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            presentAlert()
        }else{
            print("Got Current User !!")
        }
    }
    
    func presentAlert(){
        let alertController = UIAlertController(title: "Error", message: "Login Required.", preferredStyle: .alert)
               
//               let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//                   self.navigationController?.popViewController(animated: true)
//               }
               
               let login = UIAlertAction(title: "Login", style: .default) { (action) in
                    self.presentLoginController()
               }
               
//               alertController.addAction(cancel)
               alertController.addAction(login)
               present(alertController, animated: true, completion: nil)
               
    }
    
    
    // function to load the SellerLoginStorboard
     func presentLoginController(){
        let storyboard = UIStoryboard(name: Storyboard.SellerLoginStoryboard , bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.sellerloginVC)
         present(controller, animated: true, completion: nil)
         
     }
    
  
    
}
