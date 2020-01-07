//
//  ActiveUserViewController.swift
//  Best Friend Check
//
//  Created by Mark Lawrence on 11/26/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//
//
//  NewFriendCheck.swift
//  Best Friend Check
//
//  Created by Mark Lawrence on 11/26/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//


import Foundation
import Firebase

struct ActiveUser {
    
    let ref: DatabaseReference?
    let key: String
    
    let mark: Bool
    let justin: Bool
    let allison: Bool
    let nicole: Bool
    let ellie: Bool
    let molly: Bool
    
    init(mark: Bool, justin: Bool, allison: Bool, nicole: Bool, ellie: Bool, molly: Bool, key: String = "") {
        self.ref = nil
        self.key = key
        self.mark = mark
        self.justin = justin
        self.allison = allison
        self.nicole = nicole
        self.molly = molly
        self.ellie = ellie
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let mark = value["mark"] as? Bool,
            let justin = value["justin"] as? Bool,
            let allison = value["allison"] as? Bool,
            let nicole = value["nicole"] as? Bool,
            let molly = value["molly"] as? Bool,
            let ellie = value["ellie"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.mark = mark
        self.justin = justin
        self.allison = allison
        self.nicole = nicole
        self.molly = molly
        self.ellie = ellie
    }
    
    func toAnyObject() -> Any {
        return [
            "mark": mark,
            "justin": justin,
            "allison": allison,
            "nicole": nicole,
            "ellie": ellie,
            "molly": molly
        ]
    }
}
