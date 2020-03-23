//
//  LoginVC.swift
//  Artable
//
//  Created by Martin Parker on 10/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class LoginVC: UIViewController {
    
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
    //    override func viewWillDisappear(_ animated: Bool) {
    //        listener.remove()
    //    }
    
    func setupUserProfile(){
        listener = db.collection("users").whereField("id", isEqualTo: Auth.auth().currentUser?.uid).addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let user = User.init(data: data)
                
                
                let AuthID = ("\(Auth.auth().currentUser?.uid ?? "")")
                
                if AuthID == user.id {
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.activityIndicator.stopAnimating()
                    self.simpleAlert(title: "Error", msg: "Access denied!")
                    
                }
                
            })
        })
        
        
    }
    func setupUserProfile2(){
        listener = db.collection("order").whereField("customerId", isEqualTo: "abc").addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let orders = Order.init(data: data)
                
                
                // let AuthID = ("\(Auth.auth().currentUser?.uid ?? "")")
                
                //          if AuthID == user.id {
                //                 self.activityIndicator.stopAnimating()
                //                 self.dismiss(animated: true, completion: nil)
                //          }else{
                //              self.activityIndicator.stopAnimating()
                //              self.simpleAlert(title: "Error", msg: "Access denied!")
                //          }
                if orders.isCompleted == true {
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                    self.listener.remove()
                }else {
                    self.activityIndicator.stopAnimating()
                    self.simpleAlert(title: "Error", msg: "Access denied!")
                    self.emailTxt.text = ""
                    self.passTxt.text = ""
                    try! Auth.auth().signOut()
                }
                
            })
        })
        
        
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
                    //
                    //                   var userName =  UserService.getUserType()
                    //                    print(userName)
                    //UserService.getUserType()
                    //self.setupUserProfile()
                    //self.setupUserProfile2()
                    
                    print("Sign-in Sucess")
                    self.activityIndicator.stopAnimating()
                    //  self.dismiss(animated: true, completion: nil)
                    
                    let storyboard = UIStoryboard(name: Storyboard.Main , bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.mainTabVC)
                    self.present(controller, animated: true) {
                        
                        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard , bundle: nil)
                        let controller2 = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
                        controller2.dismiss(animated: true, completion: nil)
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //    self.navigationController?.popToRootViewController(animated: true)
                    
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
