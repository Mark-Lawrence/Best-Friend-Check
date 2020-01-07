//
//  BestFriendCheckHandler.swift
//  BestFriendCheckIntent
//
//  Created by Mark Lawrence on 11/30/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import Foundation

class NewFriendCheckIntentHandler: NSObject, NewFriendCheckIntentHandling {
    
    func confirm(intent: NewFriendCheckIntent, completion: @escaping (NewFriendCheckIntentResponse) -> Void) {
        completion(NewFriendCheckIntentResponse(code: .ready, userActivity: nil))
        //print("Confirm intent")
        NSLog("Confirm the intent")
        /*
        let photoInfoController = PhotoInfoController()
        photoInfoController.fetchPhotoOfTheDay { (photoInfo) in
            if let photoInfo = photoInfo {
                if photoInfo.isImage {
                    completion(PhotoOfTheDayIntentResponse(code: .ready, userActivity: nil))
                } else {
                    completion(PhotoOfTheDayIntentResponse(code: .failureNoImage, userActivity: nil))
                }
            }
        }
 */
        
    }
    
    func handle(intent: NewFriendCheckIntent, completion: @escaping (NewFriendCheckIntentResponse) -> Void) {
        //let defaults = UserDefaults.standard
        //let userID = defaults.string(forKey: "userID")
        var userID = "test"
        
        if let userDefaults = UserDefaults(suiteName: "group.marklawrence.Best-Friend-Check-group-id") {
            userID = userDefaults.string(forKey: "userID")!
        }
        let newCheckController = SendNewFriendCheck()
        //print("Send intent")
        NSLog("Send the intent")
        newCheckController.testURLRequest(userID: userID)
        completion(NewFriendCheckIntentResponse(code: .success, userActivity: nil))
        //completion(NewFriendCheckIntentResponse.success(photoTitle: "photoInfo.title"))
        //completion(NewFriendCheckIntentResponse.)
    }
}
