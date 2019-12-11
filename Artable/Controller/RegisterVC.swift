//
//  RegisterVC.swift
//  Artable
//
//  Created by Martin Parker on 10/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    // Outlet
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        
        guard let passTxt = passwordTxt.text else {return}
        
        // Show the checkmark if we have started typing in the confirm password textfield
        if textField == confirmPassTxt{
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        }else{
            passCheckImg.isHidden = true
            confirmPassCheckImg.isHidden = true
            confirmPassTxt.text = ""
        }
        
        // Make it so when the password match, the checkmark turn green
        if passwordTxt.text == confirmPassTxt.text {
            passCheckImg.image = UIImage(named: AppImage.GreenCheck)
            confirmPassCheckImg.image = UIImage(named: AppImage.GreenCheck)
        }else{
            passCheckImg.image = UIImage(named: AppImage.RedCheck)
            confirmPassCheckImg.image = UIImage(named: AppImage.RedCheck)
        }
        
    }
    
    //Action
    @IBAction func registerClicked(_ sender: UIButton) {
 
        activityIndicator.startAnimating()
        
        if let email = emailTxt.text, email.isNotEmpty, let username = usernameTxt.text, username.isNotEmpty , let password = passwordTxt.text, password.isNotEmpty {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
              
                if error == nil {
                    //User create success, navigate to another ViewController
                    print ("register success")
                    self.activityIndicator.stopAnimating()
                    
                }else{
                    print(error?.localizedDescription)
                    
                    let alert = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.activityIndicator.stopAnimating()
                }
            }
        }else{
           let alert = UIAlertController(title: "Oops!", message: "Please Fill in all the Required Fields", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
            
            self.activityIndicator.stopAnimating()
            
        }

    }
    
    
    

}
