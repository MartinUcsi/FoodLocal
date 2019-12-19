//
//  LoginVC.swift
//  Artable
//
//  Created by Martin Parker on 10/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
    }
    
    @IBAction func forgotPassClicked(_ sender: UIButton) {
        
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        
        if let email = emailTxt.text, email.isNotEmpty, let password = passTxt.text, password.isNotEmpty {
        
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
              
                if error == nil {
                    // User sign-in success, nagivate to HomeVC
                    print("Sign-in Sucess")
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                    
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
    
    @IBAction func guestClicked(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
}
