//
//  AddEditCategoryVC.swift
//  ArtableAdmin
//
//  Created by Martin Parker on 23/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Firebase

class AddEditCategoryVC: UIViewController {

    // Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn : UIButton!
    
    var categoryToEdit : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //create a tap gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
       
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        // If we are editing, categoryToEdit != nil
        if let category = categoryToEdit{
            nameTxt.text = category.name
            addBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imgUrl){
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
        
    }
    @objc func imgTapped(_ tap:UITapGestureRecognizer){
        launchImgPicker()
    }
    
    //Action
    @IBAction func addCategoryClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument(){
        
        guard let image = categoryImg.image, let categoryName = nameTxt.text, categoryName.isNotEmpty else{
                simpleAlert(title: "Error", msg: "Must add category and name")
                activityIndicator.stopAnimating()
                return
        }
        //Step 1: Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        
        //Step 2: Create an storage image reference -> A location in Firestorage for it to be stored.
        let imageRef  = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
    
        //Step 3: Set the meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //Step 4: Upload the data.
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload the image.")
                return
            }else{
                //Step 5: Once the image is uploaded, retrieve the download URL.
                       
               imageRef.downloadURL { (url, error) -> Void in
                   
                   if let error = error {
                       self.handleError(error: error, msg: "Unable to retrieve image Url.")
                       return
                   }else{
                   guard let url = url else {return}
                   print(url)
                   
                   //Step 6: Upload the new Category document to the Firestore categories collection.
                   self.uploadDocument(url: url.absoluteString)
                   }
               }
            }
        }
    }
    
    func uploadDocument(url: String){
        var docRef: DocumentReference!
        var category = Category.init(name: nameTxt.text!,
                                     id: "",
                                     imgUrl: url,
                                     timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit{
            //We are Editing, it will update the category
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        }else{
            //New Category
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        
        
        let data = Category.modelToData(category: category)
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
extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func launchImgPicker(){
     
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {return}
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
