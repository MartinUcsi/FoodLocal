//
//  RIderLoginVC.swift
//  FoodLocalRider
//
//  Created by Martin Parker on 12/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RIderLoginVC: UIViewController {

       
    //Outlets
   
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Variable
    var users = [User]()
    var db : Firestore!
    var listener : ListenerRegistration!
      
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
       
    }
    
    @IBAction func forgotPassClicked(_ sender: Any) {
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

                        print("Rider Sign-in Sucess")
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
    
 
}
