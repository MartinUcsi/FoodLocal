//
//  SellerHomeVC.swift
//  FoodLocalSeller
//
//  Created by Martin Parker on 12/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SellerHomeVC: UIViewController {
  
    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variable
    var categories = [Category]()
    var selectedCategory : Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupCollectionView()
        
    }
    
    
    func setupCollectionView(){
       collectionView.delegate = self
       collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.SellerCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.SellerCell)
    }
    
       
     override func viewDidAppear(_ animated: Bool) {
         setCategoriesListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
        func setCategoriesListener(){
            
            guard let sellerRef = Auth.auth().currentUser?.uid else {return}
            listener = db.collection("categories").whereField("sellerId", isEqualTo: sellerRef ).addSnapshotListener({ (snap, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                snap?.documentChanges.forEach({ (change) in
                    let data = change.document.data()
                    let category = Category.init(data: data)

                    switch change.type {
                    case .added:
                        self.onDocumentAdded(change:change,category: category)
                    case .modified:
                        self.onDocumentModified(change: change, category: category)
                    case .removed:
                        self.onDocumentRemoved(change: change)
                    }
                })
            })
        }
        
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
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
    
    func presentLoginController(){
        let storyboard = UIStoryboard(name: Storyboard.SellerLoginStoryboard , bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.sellerloginVC)
         present(controller, animated: true, completion: nil)
         
     }
    
    
    
    }
    


extension SellerHomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func onDocumentAdded(change: DocumentChange, category: Category){
          
          let newIndex = Int(change.newIndex)
          categories.insert(category, at: newIndex)
          collectionView.insertItems(at:[IndexPath(item: newIndex, section: 0)])
      }
      func onDocumentModified(change: DocumentChange, category: Category){
          if change.newIndex == change.oldIndex {
              //Item changed, but remained in the same position
              let index = Int(change.newIndex)
              categories[index] = category
              collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
          }else{
              //Item changed and changed position
              let oldIndex = Int(change.oldIndex)
              let newIndex = Int(change.newIndex)
              categories.remove(at: oldIndex)
              categories.insert(category, at: newIndex)
              
              collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
          }
          
      }
      func onDocumentRemoved(change: DocumentChange){
          let oldIndex = Int(change.oldIndex)
          categories.remove(at: oldIndex)
          collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
      }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
              if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.SellerCell, for: indexPath) as? SellerCell {
                  
                  cell.configureCell(category: categories[indexPath.item])
                  return cell
              }
              return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width - 30)
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          selectedCategory = categories[indexPath.row]
          performSegue(withIdentifier: Segues.toSellerProductsVC, sender: self)
          
      }
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == Segues.toSellerProductsVC {
              if let destination = segue.destination as? SellerProductsVC{
                  destination.category = selectedCategory
              }
          }
      }
    
}


