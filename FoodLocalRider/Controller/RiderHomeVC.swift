//
//  RiderHomeVC.swift
//  FoodLocalRider
//
//  Created by Martin Parker on 12/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class RiderHomeVC: UIViewController{
  
     //Outlets
       
        @IBOutlet weak var tableView: UITableView!
        
        
        
        
        //Variables
        var orders = [Order]()
        var selectedOrder : Order!
        var db : Firestore!
        var listener : ListenerRegistration!
        var riderListener : ListenerRegistration!
        var riderIdRef : String = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
            db = Firestore.firestore()
            setupTableView()
            
        }
        
     
        func setupTableView(){
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: Identifiers.RiderOrderCell, bundle: nil), forCellReuseIdentifier: Identifiers.RiderOrderCell)
            
        }
        override func viewWillAppear(_ animated: Bool) {
            setOrderListener()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            
            if Auth.auth().currentUser == nil {
                    presentAlert()
                }else{
                    print("Got Current User !!")
                }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
              listener.remove()
              riderListener?.remove()
              riderIdRef = ""
              orders.removeAll()
              tableView.reloadData()
              
        }
        
        func setRidersListener(){
           riderListener =  db.collection("order").document(selectedOrder.id).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                  print("Error fetching document: \(error!)")
                  return
                }
                guard let data = document.data() else {
                  print("Document data was empty.")
                  return
                }
                print("Current data: \(data)")
                  self.riderIdRef = document.get("riderId") as? String ?? ""
              }
          }
        
    //    func setRidersListener(){
    //        db.collection("order").document(order.id).addSnapshotListener { documentSnapshot, error in
    //          guard let document = documentSnapshot else {
    //            print("Error fetching document: \(error!)")
    //            return
    //          }
    //          guard let data = document.data() else {
    //            print("Document data was empty.")
    //            return
    //          }
    //          print("Current data: \(data)")
    //            self.orderId.text = document.get("id") as? String
    //            self.riderId.text = document.get("riderId") as? String
    //            self.riderIdRef = document.get("riderId") as? String ?? ""
    //        }
    //    }

        func checkRiderAuthority(order : Order){
            
            
            if riderIdRef != "" {
                self.dismiss(animated: true) {
                    let alertController = UIAlertController(title: "Sorry", message: "The Current order already taken by the other rider, Please try to take another order.", preferredStyle: .alert)
                    
                    let OK = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    alertController.addAction(OK)
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{
                performSegue(withIdentifier: Segues.toAcceptOrderVC, sender: self)
                updateRiderId(order: order)
                
            }
        }
        
        func updateRiderId(order : Order){
            
           
            guard let riderRef = Auth.auth().currentUser?.uid else {return}
            
                    let completeRef = db.collection("order").document(order.id)
            
                        completeRef.updateData([
                            "riderId": riderRef,
                            "statusPic" : 2,
                            "status" : "One of our rider has accept your order",
                            "estimateTime" : 30
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
            
        }
        
        func orderCompleted(order: Order) {
    //
    //         guard let riderRef = Auth.auth().currentUser?.uid else {return}
    //
    //        let completeRef = db.collection("order").document(order.id)
    //
    //            completeRef.updateData([
    //                "riderId": riderRef
    //            ]) { err in
    //                if let err = err {
    //                    print("Error updating document: \(err)")
    //                } else {
    //                    print("Document successfully updated")
    //                }
    //            }
    //        selectedOrder = orders[indexPath.row]
          //   performSegue(withIdentifier: Segues.toAcceptOrderVC, sender: self)
        }
            
        
        func setOrderListener(){
             
            listener = db.collection("order").whereField("isCompleted", isEqualTo: false)
                .whereField("riderId", isEqualTo: "")
                .order(by: "timeStamp", descending: true).addSnapshotListener({ (snap, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                snap?.documentChanges.forEach({ (change) in
                    let data = change.document.data()
                    let order = Order.init(data: data)
                    
                    switch change.type {
                        
                    case .added:
                        self.onDocumentAdded(change: change, order: order)
                    case .modified:
                        self.onDocumentModified(change: change, order: order)
                    case .removed:
                        self.onDocumentRemoved(change: change)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                })
            })
            
        }
        
        
        @IBAction func logoutClicked(_ sender: Any) {
            if let _ = Auth.auth().currentUser {
                 // We are logged in
                 do{
                     try Auth.auth().signOut()
                     UserService.logOutUser()
                     presentLoginController()
                     print("Logout success")
                 }catch{
                     print(error.localizedDescription)
                     //Give user UIAlert to show them error
                     Auth.auth().handleFireAuthError(error: error, vc: self)
                 }
             }else{
                 // User haven't logged in
                 presentLoginController()
             }
        }
        func presentAlertAccept(order: Order){
            let alertController = UIAlertController(title: "Dear Rider", message: "Do you want to take this order?", preferredStyle: .alert)
            
            let confirm = UIAlertAction(title: "Confirm", style: .default) { (action) in
    //            self.performSegue(withIdentifier: Segues.toAcceptOrderVC, sender: self)
    //            self.updateRiderId(order: order)
                  self.checkRiderAuthority(order: order)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            //confirm.setValue(AppColors.blue, forKey: "titleTextColor")
            cancel.setValue(AppColors.red, forKey: "titleTextColor")
            
            alertController.addAction(confirm)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        
        func presentAlert(){
            let alertController = UIAlertController(title: "Error", message: "Login Required.", preferredStyle: .alert)
            
            let login = UIAlertAction(title: "Login", style: .default) { (action) in
                self.presentLoginController()
                
            }
            alertController.addAction(login)
            present(alertController, animated: true, completion: nil)
        }
        // function to load the SellerLoginStorboard
        func presentLoginController(){
            let storyboard = UIStoryboard(name: Storyboard.RiderLoginStoryboard , bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.RiderloginVC)
            present(controller, animated: true, completion: nil)
            
        }
    }


    extension RiderHomeVC : UITableViewDelegate, UITableViewDataSource{
        
        
        func onDocumentAdded(change: DocumentChange, order: Order){
            let newIndex = Int(change.newIndex)
            orders.insert(order, at: newIndex)
            tableView.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: .top)
        }
        func onDocumentModified(change: DocumentChange, order: Order){
            if change.newIndex == change.oldIndex {
                //Item Changed, but remained in the same position
                let index = Int(change.newIndex)
                orders[index] = order
                tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            }else{
                //Item Changed and Changed position
                let oldIndex = Int(change.oldIndex)
                let newIndex = Int(change.newIndex)
                orders.remove(at: oldIndex)
                orders.insert(order, at: newIndex)
                
                tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
            }
            
        }
        
        func onDocumentRemoved(change: DocumentChange){
            let oldIndex = Int(change.oldIndex)
            orders.remove(at: oldIndex)
            tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .automatic)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return orders.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.RiderOrderCell, for: indexPath) as? RiderOrderCell {
                
                cell.configureCell(order: orders[indexPath.row])
                
                
                
                return cell
                
            }
            return UITableViewCell()
        
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               
               return 200
           }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            selectedOrder = orders[indexPath.row]
            setRidersListener()
            presentAlertAccept(order: selectedOrder)
            
            
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == Segues.toAcceptOrderVC {
                if let destination = segue.destination as? RiderAcceptOrderVC {
                    
                    destination.order = selectedOrder
                }
            
            }
        }

        
    }

