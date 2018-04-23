//
//  LoginViewController.swift
//  Insta
//
//  Created by Yermakov Anton on 19.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        guard emailField.text != "", pwField.text != "" else { return }
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: pwField.text!, completion: { (user, error) in
            if let error = error {
                self.errorLbl.text = error.localizedDescription
            }
            
            if let _ = user {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
  

}
