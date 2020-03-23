//
//  SearchBarVC.swift
//  FoodLocal
//
//  Created by Martin Parker on 06/03/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class SearchBarVC: UIViewController, UISearchBarDelegate {
    
    //Outlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variable
    var categories = [Category]()
    //current categories array
    //  var currentCategories = [Category]() //update collection view
    
    var selectedCategory : Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    var listener2 : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupCollectionView()
        setUpSearchBar()
        
        searchBar.placeholder = "Search for food"
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // setCategoriesListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener?.remove()
        categories.removeAll()
        searchBar.text = ""
        collectionView.reloadData()
    }
    
    func setCategoriesListener(){
        
        
        listener = db.categories.addSnapshotListener({ (snap, error) in
            
            //  listener = db.collection("categories").whereField("arrayName", arrayContains: "tart").addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category.init(data: data)
                
                //                print(category.id)
                //
                //                if category.id == "16hwqKFBp46saNuU3ykL"{
                //                    print("success! matching")
                //                }
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change:change,category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            })
        })
    }
    
    
    private func setUpSearchBar(){
        searchBar.delegate = self
        
    }
    
    func searchCategories(text: String){
        
        listener = db.collection("categories").whereField("arrayName", arrayContains: text).addSnapshotListener({ (snap, error) in
            
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
                
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            })
        })
    }
    //Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            categories.removeAll()
            collectionView.reloadData()
            return
        }
        
        guard let text = searchBar.text else { return }
        searchCategories(text: text.lowercased())
        
        // return category.name.lowercased().contains(searchText.lowercased())
        
    }
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        guard let text = searchBar.text else { return }
    //
    //        searchCategories(text: text.lowercased())
    //    }
}

extension SearchBarVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
        }
    }
    
    
    
    
}
