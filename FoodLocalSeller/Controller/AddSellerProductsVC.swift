//
//  AddSellerProductsVC.swift
//  FoodLocalSeller
//
//  Created by Martin Parker on 13/02/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AddSellerProductsVC: UIViewController {

    //Outlets
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImgView: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    
    //Variable
    
    var selectedCategory : Category!
    var productToEdit : Product?
    
    var name = ""
    var price = 0.0
    var productDescription = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a tap gesture recognizer
          let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
          
          tap.numberOfTapsRequired = 1
          productImgView.isUserInteractionEnabled = true
          productImgView.addGestureRecognizer(tap)

          // If we are editing, productToEdit != nil
          if let product = productToEdit{
              productNameTxt.text = product.name
              productDescTxt.text = product.productDescription
              productPriceTxt.text = String(product.price)
              addBtn.setTitle("Save Changes", for: .normal)

              if let url = URL(string: product.imageUrl){
                  productImgView.contentMode = .scaleAspectFill
                  productImgView.kf.setImage(with: url)

              }
          }
        print(productToEdit)
    }
    
    @objc func imgTapped(_ tap:UITapGestureRecognizer){
        launchImgPicker()
    }
    
    @IBAction func addProductClicked(_ sender: RoundedButton) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument(){
        
        guard let image = productImgView.image, let name = productNameTxt.text, name.isNotEmpty,
            let description = productDescTxt.text, description.isNotEmpty,
            let priceString = productPriceTxt.text, priceString.isNotEmpty,
                let price = Double(priceString) else{
            
                simpleAlert(title: "Error", msg: "Must fill in all the field")
                activityIndicator.stopAnimating()
                return
        }
        
        self.name = name
        self.productDescription = description
        self.price = price
         activityIndicator.startAnimating()
        
        // Step 1 : Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        //Step 2 : Create an storage image reference -> A location in Firestorage for it to be stored.
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        
        //Step 3 : Set the meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //Step 4: Upload the data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload the image")
                return
            }else{
                //Step 5 : Once the image is upload, retrieve the download URL.
                
                imageRef.downloadURL { (url, error) in
                    
                    if let error = error {
                        self.handleError(error: error, msg: "Unable to retrieve image Url")
                        return
                    }else{
                        guard let url = url else { return }
                        print (url)
                        
                        // Step 6 : Upload the new Product to the Firestore products collection.
                        self.uploadDocument(url: url.absoluteString)
                     }
                }
            }
        }
        
    }
    
    func uploadDocument(url: String){
        var docRef: DocumentReference!
        var product = Product.init(name: name,
                                   id: "",
                                   category: selectedCategory.id,
                                   price: price,
                                   productDescription: productDescription,
                                   imageUrl: url)
        
        
        if let productToEdit = productToEdit{
            // We are editing a product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        
        }else{
            // we are adding a new product
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                 self.handleError(error: error, msg: "Unable to upload new category to firestore")
                 return
            }
             self.navigationController?.popViewController(animated: true)
        }
        
    }
    
   func handleError(error: Error, msg: String){
       debugPrint(error.localizedDescription)
       self.simpleAlert(title: "Error", msg: msg)
       self.activityIndicator.stopAnimating()
   }
   
    
}


extension AddSellerProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func launchImgPicker(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        productImgView.contentMode = .scaleAspectFill
        productImgView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
