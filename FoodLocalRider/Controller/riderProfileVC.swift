//
//  riderProfileVC.swift
//  FoodLocalRider
//
//  Created by Martin Parker on 20/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class riderProfileVC: UIViewController {

    //Outlet
    @IBOutlet weak var riderNameTxt: UILabel!
    @IBOutlet weak var riderIncomeTxt: UILabel!
    
    //Variable
    var db : Firestore!
    var riderIncome : Double = 0.0
    var listener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         db = Firestore.firestore()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setRiderListener()
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }

    func setRiderListener(){
        
        guard let riderRef = Auth.auth().currentUser?.uid else {return}
              
         
            listener = db.collection("riders").document(riderRef).addSnapshotListener { documentSnapshot, error in
               guard let document = documentSnapshot else {
                 print("Error fetching document: \(error!)")
                 return
               }
               guard let data = document.data() else {
                 print("Document data was empty.")
                 return
               }
               print("Current data: \(data)")
                self.riderNameTxt.text = document.get("username") as? String ?? ""
                self.riderIncome = document.get("riderIncome") as? Double ?? 0.00
                
                //Show rider Income
               let formatter = NumberFormatter()
               formatter.numberStyle = .currency
                if let price = formatter.string(from: self.riderIncome as NSNumber){
                         self.riderIncomeTxt.text = price
                     }
                //self.riderIncomeTxt.text = "MYR \(document.get("riderIncome") as? String ?? " --")"
                 
               
             
             }
        
    }
    
    
    @IBAction func transferClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func checkHistoryClicked(_ sender: UIButton) {
        
    }
    
}
