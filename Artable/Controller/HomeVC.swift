//
//  viewController.swift
//  Artable
//
//  Created by Martin Parker on 09/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Firebase


class HomeVC: UIViewController {

    //Outlets
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Variable
    var categories = [Category]()
    var selectedCategory : Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupCollectionView()
        setupInitialAnonymousUser()
        
    }
    
    func setupInitialAnonymousUser(){
        if Auth.auth().currentUser == nil{
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error{
                    debugPrint(error)
                }
            }
        }
    }
    
    func setupCollectionView(){
       collectionView.delegate = self
       collectionView.dataSource = self
       collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCategoriesListener()
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            // We are logged in
            loginOutBtn.title = "Logout"
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        }else{
            loginOutBtn.title = "Login"
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    func setCategoriesListener(){
        listener = db.categories.addSnapshotListener({ (snap, error) in
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
    
    
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToFavorites, sender: self)
    }
    
    @IBAction func loginOutClicked(_ sender: UIBarButtonItem) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        if user.isAnonymous{
            presentLoginController()
        }else{
            do {
                try Auth.auth().signOut()
                UserService.logOutUser()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error{
                        debugPrint(error)
                    }
                    self.presentLoginController()
                }
            } catch {
                debugPrint(error)
            }
        }
        
        
//        if let _ = Auth.auth().currentUser {
//            // We are logged in
//            do{
//                try Auth.auth().signOut()
//                presentLoginController()
//                print("Logout success")
//            }catch{
//                print(error.localizedDescription)
//                //Give user UIAlert to show them error
//                Auth.auth().handleFireAuthError(error: error, vc: self)
//            }
//        }else{
//            // User haven't logged in
//            presentLoginController()
//        }
    }
    
    // function to load the LoginStorboard
    func presentLoginController(){
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard , bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts {
            if let destination = segue.destination as? ProductsVC{
                destination.category = selectedCategory
            }
        }else if segue.identifier == Segues.ToFavorites {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
                destination.showFavorites = true
                
            }
        }
    }
    
}

//This is the prior code, left for reference

//func fetchDocument(){
//       let docRef = db.collection("categories").document("2BhZP7c0YgBM9IXxXcfM")
//
//       listener = docRef.addSnapshotListener { (snap, error) in
//           self.categories.removeAll()
//           guard let data = snap?.data() else { return }
//           let newCategory = Category.init(data: data)
//           self.categories.append(newCategory)
//           self.collectionView.reloadData()
//       }
//
//
//   }
//
//   func fetchCollection(){
//       let collectionReference = db.collection("categories")
//
//       listener = collectionReference.addSnapshotListener { (snap, error) in
//           guard let documents = snap?.documents else { return }
//           self.categories.removeAll()
//
//           for document in documents {
//               let data = document.data()
//               let newCategory = Category.init(data: data)
//               self.categories.append(newCategory)
//           }
//           self.collectionView.reloadData()
//       }
//   }
