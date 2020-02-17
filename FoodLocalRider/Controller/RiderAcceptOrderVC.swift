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
    @IBOutlet weak var orderTimeTxt: UILabel!
    @IBOutlet weak var customerAddress: UITextView!
    @IBOutlet weak var customerNameTxt: UILabel!
    @IBOutlet weak var customerPhoneTxt: UILabel!
    @IBOutlet weak var OrderItemArrayTxt: UITextView!
    @IBOutlet weak var paymentMethodTxt: UILabel!
    @IBOutlet weak var amountTxt: UILabel!
    
    
    //Variable
    var db : Firestore!
    var order : Order!
    var riderIdRef : String = ""
    var listener : ListenerRegistration!
    var addressArray = ""
    var itemArray = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        setRidersListener()
        
        addressArray.append("\(order.lineOne) \n")
        addressArray.append("\(order.lineTwo)")
        
        for i in order.item{
            itemArray.append("\(i) \n")
           
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
         
        //show item order
        OrderItemArrayTxt.text = itemArray
        
        //Show total amount
        let formatter = NumberFormatter()
              formatter.numberStyle = .currency
              if let price = formatter.string(from: order.amount as NSNumber){
                  amountTxt.text = "Total: \(price)"
              }
              
        //Show Payment Method
        paymentMethodTxt.text = "PAYMENT METHOD: \(order.paymentMethod)"
        
        //Show Contact
        customerPhoneTxt.text = "CONTACT: \(order.phoneNumber)"
        
        //Show CustomerName
        customerNameTxt.text = "NAME: \(order.customerName)"
        
        //Show address
        customerAddress.text = addressArray
        
        //Show time
            let OrderTime = order.timeStamp
           let aDate = OrderTime.dateValue()
           let formatter2 = DateFormatter()
           formatter2.locale = Locale(identifier: "en_US_POSIX")
          // formatter2.dateFormat = "HH:mm '-' dd/MM/yyyy"
           formatter2.dateFormat = "'ORDER TIME: 'd MMM yyyy',' h:mm a"
           let formattedTimeZoneStr = formatter2.string(from: aDate)
           //print(formattedTimeZoneStr)
            
           orderTimeTxt.text = formattedTimeZoneStr
    }
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        addressArray.removeAll()
    }

//    func detectAuthorizeRider(){
//
//         guard let riderRef = Auth.auth().currentUser?.uid else {return}
//
//       // print("The riderIdRef is \(riderIdRef)")
//        if riderIdRef != riderIdRef {
//            presentAlert()
//        }
//    }
//
    func presentCancelAlert(){
        let alertController = UIAlertController(title: "Cancel Order?", message: "Are you sure you want to cancel?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes, Cancel", style: .default) { (action) in
            self.riderCancelOrder()
        }
        let stay = UIAlertAction(title: "Stay", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        yes.setValue(UIColor.red, forKey: "titleTextColor")
        stay.setValue(UIColor.darkGray, forKey: "titleTextColor")
        alertController.addAction(yes)
        alertController.addAction(stay)
        present(alertController, animated: true, completion: nil)
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
    
        func orderCompleted() {
    
//             guard let riderRef = Auth.auth().currentUser?.uid else {return}
    
            let completeRef = db.collection("order").document(order.id)
    
                completeRef.updateData([
                    "isCompleted": true
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
           
            self.navigationController?.popToRootViewController(animated: true)
        }
    
    func riderCancelOrder(){
//        guard let riderRef = Auth.auth().currentUser?.uid else {return}
//          
                  let completeRef = db.collection("order").document(order.id)
          
                      completeRef.updateData([
                          "riderId": ""
                      ]) { err in
                          if let err = err {
                              print("Error updating document: \(err)")
                          } else {
                              print("Document successfully updated")
                          }
                      }
                 
                  self.navigationController?.popToRootViewController(animated: true)
    }

    
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
        self.orderId.text = "OrderID# \(document.get("id") as? String ?? "OrderID#----")"
            self.riderIdRef = document.get("riderId") as? String ?? ""
        
        }
    }
    
    @IBAction func completeClicked(_ sender: UIButton) {
        orderCompleted()
        
    }
    
    @IBAction func cancelClicked(_ sender: RoundedButton) {
        presentCancelAlert()
    }
    
}
