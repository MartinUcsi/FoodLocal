//
//  UserService.swift
//  Artable
//
//  Created by Martin Parker on 28/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseFirestore

let UserService = _UserService()

final class _UserService {
    
    //Variable
    var user = User()
    var favorites = [Product]()
    var auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    var favsListener : ListenerRegistration? = nil
    
    var isGuest : Bool {
        
        guard let authUser  = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        }else{
            return false
        }
        
    }
    
    func getUserType(){
        guard let authUser = auth.currentUser else { return }
               
           let userRef = db.collection("users").document(authUser.uid)
           userListener = userRef.addSnapshotListener({ (snap, error) in
               
               if let error = error {
                   debugPrint(error.localizedDescription)
                   return
               }
               
               guard let data = snap?.data() else {  return }
               self.user = User.init(data: data)
               //print(self.user.username)
            
           })
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        
        let userRef = db.collection("users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else {  return }
            self.user = User.init(data: data)
            print("\(self.user)")
        })
        
        let favsRef = userRef.collection("favorites")
        favsListener = favsRef.addSnapshotListener({ (snap, error) in
            
            if let error = error  {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    
    
    func favoriteSelected(product: Product) {
        let favsRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
        
        if favorites.contains(product) {
            // We remove it as a favorite
            favorites.removeAll { $0 == product }
            favsRef.document(product.id).delete()
        }else{
            // Add as a favorite
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favsRef.document(product.id).setData(data)
            
        }
        
    }
    
    func logOutUser(){
        userListener?.remove()
        userListener = nil
        favsListener?.remove()
        favsListener = nil
        user = User()
        favorites.removeAll()
       
        
    }
    

}
