//
//  ViewController.swift
//  ArtableAdmin
//
//  Created by Martin Parker on 09/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Firebase

class AdminHomeVC: HomeVC {

    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    //variable
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginOutBtn.isEnabled = false
        
        

        let LogoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(backAdminLogin))
        navigationItem.rightBarButtonItem = LogoutBtn
        

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
         if let user = Auth.auth().currentUser {
                    // We are logged in
                   // loginOutBtn.title = "Logout"
                   // print("havent logout")
                let LogoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(backAdminLogin))
                navigationItem.rightBarButtonItem = LogoutBtn
            
        //            if UserService.userListener == nil {
        //                UserService.getCurrentUser()
        //            }
                }else{
            let LoginBtn = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(backAdminLogin))
            navigationItem.rightBarButtonItem = LoginBtn
                    //loginOutBtn.title = "Login"
                     //print ("Havent Login")
                }
    }
    
    
    @IBAction func addClicked(_ sender: Any) {
       //Segues to the add category view
        
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
       
    }
    
    @IBAction func orderClicked(_ sender: Any) {
        
    }
    
    
    @objc func backAdminLogin(){
        //Segues to the Admin login view
        //Perform Logout
        
        
           if let _ = Auth.auth().currentUser {
               // We are logged in
               do{
                   try Auth.auth().signOut()
                   performSegue(withIdentifier: Segues.BackToLoginAdmin , sender: self)
                   print("Logout success")
               }catch{
                   print(error.localizedDescription)
                   //Give user UIAlert to show them error
                   Auth.auth().handleFireAuthError(error: error, vc: self)
               }
           }else{
               // User haven't logged in
               performSegue(withIdentifier: Segues.BackToLoginAdmin , sender: self)
           }
    }
}

