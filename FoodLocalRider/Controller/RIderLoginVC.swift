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
    override func viewWillDisappear(_ animated: Bool) {
        listener?.remove()
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
                        //Check User permission
                      //  self.checkUserPermission()
                        guard let riderRef = Auth.auth().currentUser?.uid else {return}
                        self.checkUserPermission(idRef: riderRef)
                       // print(riderRef)
//                        print("Rider Sign-in Sucess")
//                        self.activityIndicator.stopAnimating()
//                        self.dismiss(animated: true, completion: nil)
                        
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
    
    func checkUserPermission(idRef: String){
      
        
              listener = db.collection("riders").document(idRef).addSnapshotListener { documentSnapshot, error in
               guard let document = documentSnapshot else {
                 print("Error fetching document: \(error!)")
                 return
               }
               guard let data = document.data() else {
                //here is the user is invalid
                do {
                    self.activityIndicator.stopAnimating()
                    self.simpleAlert(title: "Invalid account!", msg: "Your account is not yet registered on our server.")
                    try Auth.auth().signOut()
                    UserService.logOutUser()
                } catch {
                    debugPrint(error)
                }
                 print("Document data was empty.")
                 print("Invalid Rider Account")
                 return
               }
                
                //here the user is valid
                print("Rider valid")
               print("Current data: \(data)")
                
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
                
                
                
                
         //    self.orderId.text = "OrderID# \(document.get("id") as? String ?? "OrderID#----")"
//                 self.riderIdRef = document.get("riderId") as? String ?? ""
//
//                 if self.riderIdRef != riderRef {
//                     self.presentAlert()
//                 }
             
             }
    }
    
    
   
 
}




