//
//  RegisterVC.swift
//  Artable
//
//  Created by Martin Parker on 10/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    // Outlet
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        
        guard let passTxt = passwordTxt.text else {return}
        
        // Show the checkmark if we have started typing in the confirm password textfield
        if textField == confirmPassTxt{
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        }else{
            passCheckImg.isHidden = true
            confirmPassCheckImg.isHidden = true
            confirmPassTxt.text = ""
        }
        
        // Make it so when the password match, the checkmark turn green
        if passwordTxt.text == confirmPassTxt.text {
            passCheckImg.image = UIImage(named: AppImage.GreenCheck)
            confirmPassCheckImg.image = UIImage(named: AppImage.GreenCheck)
        }else{
            passCheckImg.image = UIImage(named: AppImage.RedCheck)
            confirmPassCheckImg.image = UIImage(named: AppImage.RedCheck)
        }
        
    }
    
    //Action
    @IBAction func registerClicked(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        
        
        if let email = emailTxt.text, email.isNotEmpty, let username = usernameTxt.text, username.isNotEmpty , let password = passwordTxt.text, password.isNotEmpty {
            
            guard let confirmPass = confirmPassTxt.text, confirmPass == password else {
                simpleAlert(title: "Error", msg: "Passwords do not match.")
                activityIndicator.stopAnimating()
                return
            }
            
//            guard let authUser = Auth.auth().currentUser else{
//                return
//            }
//
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                           
                           
                           if error == nil {
                               //User create success, navigate to another ViewController
                               print ("register success")
                               
                               guard let firUser = authResult?.user else { return }
                               let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
                               // Upload to firestore
                               
                               self.createFirestoreUser(user: artUser)
                               
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
            
            
//            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
//
//            authUser.link(with: credential) { (result, error) in
//
//                if let error = error {
//                    //Give user UIAlert to show them error
//                    Auth.auth().handleFireAuthError(error: error, vc: self)
//                    self.activityIndicator.stopAnimating()
//
//                }else{
//
//                    guard let firUser = result?.user else { return }
//                    let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
//                    // Upload to firestore
//                    self.createFirestoreUser(user: artUser)
//
//                }
//
//            }
//
//            //            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            //
//            //
//            //                if error == nil {
//            //                    //User create success, navigate to another ViewController
//            //                    print ("register success")
//            //                    self.activityIndicator.stopAnimating()
//            //                    self.dismiss(animated: true, completion: nil)
//            //                }else{
//            //                    print(error?.localizedDescription)
//            //
//            //                    //Give user UIAlert to show them error
//            //                    Auth.auth().handleFireAuthError(error: error!, vc: self)
//            //                    self.activityIndicator.stopAnimating()
//            //                }
//            //            }
//        }else{
//            //Give user UIAlert to show them error
//            self.simpleAlert(title: "Oops!", msg: "Please fill in all the required fields")
//            self.activityIndicator.stopAnimating()
//
//        }
            
            
        
    }
    
    func createFirestoreUser(user: User){
        // Step 1: Create document reference
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        
        // Step 2: Create model data
        let data = User.modelToData(user: user)
        
        // Step3: Upload to Firestore
        newUserRef.setData(data) { (error) in
            if let error = error{
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint("Unable to upload new user document : \(error.localizedDescription)")
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    
    
}
