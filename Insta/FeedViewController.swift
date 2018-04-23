//
//  FeedViewController.swift
//  Insta
//
//  Created by Yermakov Anton on 30.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    var following = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

       fetchPost()
    }
    
    func fetchPost(){
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
        
            let users = snapshot.value as! [String : AnyObject]
            
            for (_, value) in users{
                if let uid = value["uid"] as? String{
                    if uid == FIRAuth.auth()!.currentUser!.uid{
                        if let followingUser = value["following"] as? [String : String]{
                            for (_, user) in followingUser{
                                self.following.append(user)
                            }
                        }
                        self.following.append(FIRAuth.auth()!.currentUser!.uid)
                        
                        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                        
                            let postsSnap = snap.value as! [String : AnyObject]
                            for (_, posts) in postsSnap{
                                if let userID = posts["userID"] as? String{
                                    for each in self.following{
                                        if each == userID{
                                            
                                            let posst = Post()
                                            
                            if let author = posts["author"] as? String, let userID = posts["userID"] as? String, let postID = posts["postID"] as? String, let likes = posts["likes"] as? Int, let pathToImage = posts["pathToImage"] as? String{
                                                
                                                posst.author = author
                                                posst.likes = likes
                                                posst.pathToImage = pathToImage
                                                posst.postID = postID
                                                posst.userID = userID
                                
                                if let people = posts["peopleWhoLike"] as? [String : AnyObject] {
                                    for (_,person) in people {
                                        posst.peopleWhoLikes.append(person as! String)
                                    }
                                }

                                
                                                self.posts.append(posst)
                                            }
                                        }
                                    }
                                    self.collectionView.reloadData()
                                }
                            }
                            
                        })
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        
        cell.authorLbl.text = self.posts[indexPath.row].author
        cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.likesLbl.text = "\(self.posts[indexPath.row].likes!) Likes"
        cell.postID = self.posts[indexPath.row].postID
        
        
        for person in self.posts[indexPath.row].peopleWhoLikes {
            if person == FIRAuth.auth()!.currentUser!.uid {
                cell.likeBtn.isHidden = true
                cell.unlikeBtn.isHidden = false
                break
            }
        }

        
       
        
        return cell 
    }

   
}
