//
//  HomeViewController.swift
//  Insta
//
//  Created by Yermakov Anton on 31.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    var photos = [Photos]()
    let uid = FIRAuth.auth()!.currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

       fetchPhotos()
    }
    
    
    func fetchPhotos(){
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("posts").queryOrderedByKey().observe(.value, with: { (snapshot) in
            
            let posts = snapshot.value as! [String : AnyObject]
            
            for (_, value) in posts{
                if let userID = value["userID"] as? String{
                    if userID == self.uid{
                        let phottto = Photos()
                        
                        if let pathToImage = value["pathToImage"] as? String{
                            phottto.photos = pathToImage
                            self.photos.append(phottto)
                        }
                    }
                    
                }
                
            }
            self.myCollectionView.reloadData()
        })
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotosCollectionViewCell
        
        cell.myPhoto.downloadImage(from: self.photos[indexPath.row].photos)
        
        return cell
    }

    

}
