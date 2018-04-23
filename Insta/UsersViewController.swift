//
//  UsersViewController.swift
//  Insta
//
//  Created by Yermakov Anton on 21.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    
    var user = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
  
        retriveUsers()
    }
    
    func retriveUsers(){
        
      let ref = FIRDatabase.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let users = snapshot.value as! [String : AnyObject]
            self.user.removeAll()
            
            for (_, value) in users{
                if let uid = value["uid"] as? String{
                    if uid != FIRAuth.auth()?.currentUser!.uid{
                        let userToShow = User()
                        if let fullName = value["full name"] as? String, let imagePath = value["urlToImage"] as? String{
                            userToShow.userId = uid
                            userToShow.fullName = fullName
                            userToShow.imagePath = imagePath
                            self.user.append(userToShow)
                        }
                    }
                }
            }
            self.tblView.reloadData()
        })
         ref.removeAllObservers()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.nameLabel.text = self.user[indexPath.row].fullName
        cell.userId = self.user[indexPath.row].userId
        cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath!)
        self.checkFollowing(indexPath: indexPath)
      return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        var isFollower = false
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as! String == self.user[indexPath.row].userId {
                        isFollower = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.user[indexPath.row].userId).child("followers/\(ke)").removeValue()
                        
                        self.tblView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
            }
            if !isFollower {
                let following = ["following/\(key)" : self.user[indexPath.row].userId]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("users").child(uid).updateChildValues(following)
                ref.child("users").child(self.user[indexPath.row].userId).updateChildValues(followers)
                
                self.tblView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        })
        ref.removeAllObservers()
        
    }
    
    
    func checkFollowing(indexPath: IndexPath) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as! String == self.user[indexPath.row].userId {
                        self.tblView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                }
            }
        })
        ref.removeAllObservers()
        
    }
    
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
    }
   

 

}


extension UIImageView{
    
    func downloadImage(from ImgURL: String!){
        let url = URLRequest(url: URL(string: ImgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                print("Error")
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        task.resume()
    }
}





