//
//  SignupViewController.swift
//  Insta
//
//  Created by Yermakov Anton on 18.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var comPwField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    var picker = UIImagePickerController()
    var ref : FIRDatabaseReference!
    var userStorage : FIRStorageReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://insta-8b698.appspot.com")
        userStorage = storage.child("users")
      
          }
    
    
    
    @IBAction func selectImagePressed(_ sender: UIButton) {
        
           picker.allowsEditing = true
           picker.sourceType = .photoLibrary
           present(picker, animated: true, completion: nil)
           }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageView.image = image
            nextBtn.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func nextPressed(_ sender: UIButton) {
    
        guard nameField.text != "", emailField.text != "", password.text != "", comPwField.text != "" else { return }
        
        if password.text == comPwField.text{
            
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: password.text!, completion: { (user, error) in
                
                if let error = error{
                    self.errorLbl.text = error.localizedDescription
                }
                    if let user = user{
                        
                        let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                        changeRequest.displayName = self.nameField.text!
                        changeRequest.commitChanges(completion: nil)
                        
                        let imageRef = self.userStorage.child("\(user.uid).jpg")
                        
                        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                        
                        let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, err) in
                            
                            if let err = err{
                                self.errorLbl.text = err.localizedDescription
                            }
                            
                            imageRef.downloadURL(completion: {  (url, er) in 
                                
                                if let er = er{
                                    self.errorLbl.text = er.localizedDescription
                                }
                                
                                if let url = url{
                                    
                                    let userInfo : [String : Any] = ["uid" : user.uid, "full name" : self.nameField.text!, "urlToImage" : url.absoluteString]
                                    
                                    self.ref.child("users").child(user.uid).setValue(userInfo)
                                    
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                                    self.present(vc, animated: true, completion: nil)
                                }
                                
                            })
                            
                        })
                        uploadTask.resume()
                    }
                
            })
        }

       }
    
}







