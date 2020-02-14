//
//  AdminLoginVC.swift
//  ArtableAdmin
//
//  Created by Martin Parker on 15/01/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase


class AdminLoginVC: UIViewController {

    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    
    @IBAction func loginClicked(_ sender: Any) {
        activityIndicator.startAnimating()
       
        
        if let email = emailTxt.text, email.isNotEmpty, let password = passTxt.text, password.isNotEmpty {
        
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
              
                if error == nil {
                    // User sign-in success, nagivate to HomeVC
                    print("Sign-in Sucess")
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: Segues.ToAdminHomeVC, sender: self)
                    
                }else{
                    print(error?.localizedDescription)
                    
                    //Give user UIAlert to show them error
                    Auth.auth().handleFireAuthError(error: error!, vc: self)
                    self.activityIndicator.stopAnimating()
                    
                    
                }
              
            }
        }else{
            

            //Give user UIAlert to show them error
            self.simpleAlert(title: "Oops!", msg: "Please fill in all the required fields")
            self.activityIndicator.stopAnimating()
        }
            
    }
    
  

}
