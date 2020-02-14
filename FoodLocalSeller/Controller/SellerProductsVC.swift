//
//  SellerProductsVC.swift
//  FoodLocalSeller
//
//  Created by Martin Parker on 13/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SellerProductsVC: UIViewController {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //Variable
     var products = [Product]()
     var category : Category!
     var db: Firestore!
     var listener : ListenerRegistration!
     var showFavorites = false
     var selectedProduct : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupTableView()

        
    }
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.SellerProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.SellerProductCell)
       
    }

    override func viewDidAppear(_ animated: Bool) {
          setupQuery()
          
         
      }
  override func viewWillDisappear(_ animated: Bool) {
         listener.remove()
         products.removeAll()
         tableView.reloadData()
     }
    
    @IBAction func addFoodClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.AddSellerProductOnly, sender: self)
    }
    
    
    
    func setupQuery(){
        
        var ref : Query!
         
            ref = db.products(category: category.id)
        
        
        listener = ref.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDucumentModified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
     
}

extension SellerProductsVC : UITableViewDelegate, UITableViewDataSource {
    
    func onDocumentAdded(change: DocumentChange, product: Product){
           let newIndex = Int(change.newIndex)
           products.insert(product, at: newIndex)
           tableView.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: .none)
       }
       func onDucumentModified(change: DocumentChange, product: Product){
           if change.newIndex == change.oldIndex {
               //Item changed, but remained in the same position
               let index = Int(change.newIndex)
               products[index] = product
               tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
           }else{
               //Item changed and changed position
               let oldIndex = Int(change.oldIndex)
               let newIndex = Int(change.newIndex)
               products.remove(at: oldIndex)
               products.insert(product, at: newIndex)
               
               tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item:newIndex, section: 0))
           }
       }
       func onDocumentRemoved(change: DocumentChange){
           let oldIndex = Int(change.oldIndex)
           products.remove(at: oldIndex)
           tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .left)
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.SellerProductCell, for: indexPath) as? SellerProductCell {
            
            cell.configureCell(product: products[indexPath.row])
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 200
       }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Editing Product
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.toAddSellerProductsVC, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == Segues.toAddSellerProductsVC{
                   if let destination = segue.destination as? AddSellerProductsVC  {
                       destination.selectedCategory = category
                       destination.productToEdit = selectedProduct
                   }
         }else if segue.identifier ==  Segues.AddSellerProductOnly {
            if let destination = segue.destination as? AddSellerProductsVC {
                destination.selectedCategory = category
            }
            
        }
    }
    
 
    
}
