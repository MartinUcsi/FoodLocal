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
    
    @IBOutlet weak var qrImg: UIImageView!
    
    //Variable
    
    var db : Firestore!
    var listener : ListenerRegistration!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
       
      
    }
    override func viewWillAppear(_ animated: Bool) {
        //Generate user uid QR code
               guard let sellerRef = Auth.auth().currentUser?.uid else {return}
                let imageQR = generateQRCode(from: sellerRef )
               qrImg.image = imageQR
    }
    override func viewDidAppear(_ animated: Bool) {
           setUserListener()
      
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

    
//    let data = document.data()
//    let user = User.init(data: data)
    
    
//
//    func setUsersListener(){
//
//
//
//             guard let sellerRef = Auth.auth().currentUser?.uid else {return}
//
//        let docRef = db.collection("sellers").document(sellerRef)
//
//
//        //Grabing single document from cloud firestore
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                self.sellerIdTxt.text = document.get("id") as! String
//                self.sellerNameTxt.text = document.get("username") as! String
//                self.sellerEmailTxt.text = document.get("email") as! String
//
//            } else {
//                print("Document does not exist")
//            }
//        }
//
//        }
    
    func setUserListener(){
        
         guard let sellerRef = Auth.auth().currentUser?.uid else {return}
        
        listener = db.collection("sellers").document(sellerRef).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                  print("Error fetching document: \(error!)")
                  return
                }
                guard let data = document.data() else {
                  print("Document data was empty.")
                  return
                }
                print("Current data: \(data)")
                  self.sellerIdTxt.text = document.get("id") as? String
                  self.sellerNameTxt.text = document.get("username") as? String
                  self.sellerEmailTxt.text = document.get("email") as? String
              }
    }

    
}
