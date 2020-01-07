//
//  IntentHandler.swift
//  BestFriendCheckIntent
//
//  Created by Mark Lawrence on 11/30/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        guard intent is NewFriendCheckIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        
        return NewFriendCheckIntentHandler()
    }
    
}
