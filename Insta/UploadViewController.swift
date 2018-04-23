//
//  UploadViewController.swift
//  Insta
//
//  Created by Yermakov Anton on 30.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var selectLbl: UIButton!
    @IBOutlet weak var postLbl: UIButton!
    
    var picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.postImage.image = image
            selectLbl.isHidden = true
            postLbl.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectBtn(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func postBtn(_ sender: Any) {
        
        AppDelegate.instance().showActivityIndicator()
        
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()!.currentUser!.uid
        let storage = FIRStorage.storage().reference(forURL: "gs://insta-8b698.appspot.com")
        
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.postImage.image!, 0.5)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
           
            if let error = error{
                print(error.localizedDescription)
                AppDelegate.instance().stopActivityIndicator()
            }
            
            imageRef.downloadURL(completion: { (url, err) in
                if let err = err{
                    print(err.localizedDescription)
                }
                
                if let url = url{
                    let feed = ["userID" : uid, "postID" : key, "pathToImage" : url.absoluteString, "likes" : 0, "author" : FIRAuth.auth()!.currentUser!.displayName!] as [String : Any]
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    
                    AppDelegate.instance().stopActivityIndicator()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
            })
        }
        uploadTask.resume()
    }


}






