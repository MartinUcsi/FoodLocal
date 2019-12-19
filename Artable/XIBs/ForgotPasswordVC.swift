//
//  ForgotPasswordVC.swift
//  Artable
//
//  Created by Martin Parker on 13/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }

    @IBAction func cancelClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender: UIButton) {
        guard let email = emailTxt.text, email.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please enter email.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }else{
                print(error)
                Auth.auth().handleFireAuthError(error: error!, vc: self)
                return
            }
        }
    }
    
}
