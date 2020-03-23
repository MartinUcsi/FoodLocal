//
//  UserProfileVC.swift
//  FoodLocal
//
//  Created by Martin Parker on 26/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class UserProfileVC: UIViewController {

    //Outlets
    @IBOutlet weak var userNameTxt: UILabel!
    @IBOutlet weak var userNameTxt2: RoundedLabelView!
    @IBOutlet weak var emailTxt: RoundedLabelView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    @IBOutlet weak var qrImg: UIImageView!
    
    //Variable
    var db : Firestore!
    var listener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
           setUserListener()
        
        //Generate user uid QR code
        guard let userRef = Auth.auth().currentUser?.uid else {return}
         let imageQR = generateQRCode(from: userRef )
        qrImg.image = imageQR
    }
    override func viewDidAppear(_ animated: Bool) {
      

          if let user = Auth.auth().currentUser, !user.isAnonymous {
              // We are logged in
            logoutBtn.setTitle("Log Out", for: .normal)
           //   logoutBtn.title = "Logout"
              if UserService.userListener == nil {
                  UserService.getCurrentUser()
              }
          }else{
              //logoutBtn.title = "Login"
             logoutBtn.setTitle("Login", for: .normal)
          }

         
      
    }
    override func viewWillDisappear(_ animated: Bool) {
       listener.remove()
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
//    func logOut(){
//        guard let user = Auth.auth().currentUser else { return }
//
//        if user.isAnonymous{
//            presentLoginController()
//        }else{
//            do {
//                try Auth.auth().signOut()
//                UserService.logOutUser()
//
//
//                Auth.auth().signInAnonymously { (result, error) in
//                    if let error = error{
//                        debugPrint(error)
//                    }
//
//                        self.presentLoginController()
//
//
//
//                }
//            } catch {
//                debugPrint(error)
//            }
//        }
//    }
    
    func logOut(){
        do {
            try Auth.auth().signOut()
            UserService.logOutUser()
            presentLoginController()
        }catch{
            print("Error Signing Out \(error)")
        }
    }
    
    func presentLoginController(){
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard , bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
        present(controller, animated: true, completion: nil)
        
    }

    
    func setUserListener(){
       
        guard let userRef = Auth.auth().currentUser?.uid else {return}
        
        listener = db.collection("users").document(userRef).addSnapshotListener { documentSnapshot, error in
                      guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                      }
                      guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                      }
                      print("Current data: \(data)")
                       self.userNameTxt.text = document.get("username") as? String ?? ""
                       self.userNameTxt2.text = document.get("username") as? String ?? ""
                        self.emailTxt.text = document.get("email") as? String ?? ""
                    }
        
    }
    
    @IBAction func logoutClicked(_ sender: UIButton) {
        
       
        
        logOut()
    }
    
}
