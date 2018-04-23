//
//  Post.swift
//  Insta
//
//  Created by Yermakov Anton on 30.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit

class Post: NSObject {

    var author: String!
    var likes: Int!
    var pathToImage: String!
    var userID: String!
    var postID: String!
    var peopleWhoLikes : [String] = [String]()
}
