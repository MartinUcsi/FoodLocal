//
//  RiderAcceptOrderVC.swift
//  FoodLocalRider
//
//  Created by Martin Parker on 14/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RiderAcceptOrderVC: UIViewController {

    //Outlets
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var riderId: UILabel!
    
    //Variable
      
    var db : Firestore!
    var order : Order!
    var riderIdRef : String = ""
    var listener : ListenerRegistration!
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        setRidersListener()
    }
    override func viewDidAppear(_ animated: Bool) {
              //setRidersListener()
             // print("\(order.id)")
        detectAuthorizeRider()
    }
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }

    func detectAuthorizeRider(){
        
         guard let riderRef = Auth.auth().currentUser?.uid else {return}
        
       // print("The riderIdRef is \(riderIdRef)")
        if riderIdRef != riderIdRef {
            presentAlert()
        }
    }
    func presentAlert(){
        let alertController = UIAlertController(title: "Sorry", message: "The Order already taken by other rider, Please try to take another order.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
            
        }
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
//    func setRidersListener(){
//
//
//        guard let riderRef = Auth.auth().currentUser?.uid else {return}
//
//        let docRef = db.collection("order").document(order.id)
//
//        //Grabing single document from cloud firestore
//               docRef.getDocument { (document, error) in
//                   if let document = document, document.exists {
//
//                    self.orderId.text = document.get("id") as? String
//                    self.riderId.text = document.get("rioderId") as? String
//                   } else {
//                       print("Document does not exist")
//                }
//        }
//    }
    
    func setRidersListener(){
       listener = db.collection("order").document(order.id).addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
          guard let data = document.data() else {
            print("Document data was empty.")
            return
          }
          print("Current data: \(data)")
            self.orderId.text = document.get("id") as? String
            self.riderId.text = document.get("riderId") as? String
            self.riderIdRef = document.get("riderId") as? String ?? ""
        }
    }
    
    @IBAction func completeClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
