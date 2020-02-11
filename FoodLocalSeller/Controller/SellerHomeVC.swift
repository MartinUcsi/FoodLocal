//
//  SellerHomeVC.swift
//  FoodLocalSeller
//
//  Created by Martin Parker on 12/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SellerHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        if let _ = Auth.auth().currentUser {
               // We are logged in
               do{
                   try Auth.auth().signOut()
                   UserService.logOutUser()
                   presentLoginController()
                   print("Logout success")
               }catch{
                   print(error.localizedDescription)
                   //Give user UIAlert to show them error
                   Auth.auth().handleFireAuthError(error: error, vc: self)
               }
           }else{
               // User haven't logged in
               presentLoginController()
           }
        }
    
    func presentLoginController(){
        let storyboard = UIStoryboard(name: Storyboard.SellerLoginStoryboard , bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.sellerloginVC)
         present(controller, animated: true, completion: nil)
         
     }
    
    
    
    }
    



