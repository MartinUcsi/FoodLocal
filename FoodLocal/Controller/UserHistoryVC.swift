//
//  UserHistoryVC.swift
//  FoodLocal
//
//  Created by Martin Parker on 25/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserHistoryVC: UIViewController {

    //Outlet
    @IBOutlet weak var tableView: UITableView!
    
    
    //Variable
    var orders = [Order]()
    var selectedOrder : Order!
    var db : Firestore!
    var listener : ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        setupTableView()
       
    }
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.UserOrderCell, bundle: nil), forCellReuseIdentifier: Identifiers.UserOrderCell)
    }
    override func viewWillAppear(_ animated: Bool) {
        setOrderListener()
    }
    override func viewWillDisappear(_ animated: Bool) {
         listener.remove()
         orders.removeAll()
         tableView.reloadData()
    }
    func setOrderListener(){
            guard let userRef = Auth.auth().currentUser?.uid else {return}
        
         listener = db.collection("order").whereField("isCompleted", isEqualTo: true)
             .whereField("customerId", isEqualTo: userRef)
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
             })
         })
         
     }


}

extension UserHistoryVC : UITableViewDelegate, UITableViewDataSource{
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.UserOrderCell, for: indexPath) as? UserOrderCell {
                 
                 cell.configureCell(order: orders[indexPath.row])
                 
                 
                 
                 return cell
                 
             }
             return UITableViewCell()
    }
    

    
}
