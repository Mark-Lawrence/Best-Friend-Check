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
    
    func handle(intent: BestFriendCheckIntent, completion: @escaping (BestFriendCheckIntentResponse) -> Void) {
        /*
        let photoInfoController = PhotoInfoController()
        photoInfoController.fetchPhotoOfTheDay { (photoInfo) in
            if let photoInfo = photoInfo {
                completion(PhotoOfTheDayIntentResponse.success(photoTitle: photoInfo.title))
            }
        }
 */
    }
}
