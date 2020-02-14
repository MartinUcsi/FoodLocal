//
//  SellerProfileVC.swift
//  FoodLocalSeller
//
//  Created by Martin Parker on 13/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class SellerProfileVC: UIViewController {


    
    //Outlets
    @IBOutlet weak var sellerIdTxt: UILabel!
    @IBOutlet weak var sellerNameTxt: UILabel!
    @IBOutlet weak var sellerEmailTxt: UILabel!
    
    
    //Variable
    
    var db : Firestore!
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
       
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
           setUsersListener()
      
    }
  
    
//    let data = document.data()
//    let user = User.init(data: data)
    
    
    
    func setUsersListener(){
  
            
           
             guard let sellerRef = Auth.auth().currentUser?.uid else {return}
           
        let docRef = db.collection("sellers").document(sellerRef)
        
        
        //Grabing single document from cloud firestore
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.sellerIdTxt.text = document.get("id") as! String
                self.sellerNameTxt.text = document.get("username") as! String
                self.sellerEmailTxt.text = document.get("email") as! String 
                
            } else {
                print("Document does not exist")
            }
        }
        
        }
    

    
}
