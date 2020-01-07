//
//  SendNewFriendCheck.swift
//  Best Friend Check
//
//  Created by Mark Lawrence on 11/30/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import Foundation


struct SendNewFriendCheck {
    
    let baseURL = URL(string: "https://us-central1-best-friend-check.cloudfunctions.net/addMessage?text=")!
    
    func testURLRequest(userID: String) {
        let baseURL = URL(string: "https://us-central1-best-friend-check.cloudfunctions.net/addMessage?text=\(userID)")!
        let url = baseURL
        url
        let session = URLSession.init(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error)
            in
        }
        task.resume()
    }
    
}
 
