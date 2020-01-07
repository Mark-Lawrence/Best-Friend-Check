//
//  ViewController.swift
//  Best Friend Check
//
//  Created by Mark Lawrence on 11/26/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseMessaging

import Intents


class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var allisonBackground: UIImageView!
    @IBOutlet weak var markBackground: UIImageView!
    @IBOutlet weak var mollyBackground: UIImageView!
    @IBOutlet weak var ellieBackground: UIImageView!
    @IBOutlet weak var nicoleBackground: UIImageView!
    @IBOutlet weak var justinBackground: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var checkInProgressView: UIView!
    @IBOutlet weak var checkInProgressLabel: UILabel!
    
    
    let screenSize = UIScreen.main.bounds
    
    var bestFriendCheckRef: DatabaseReference!
    let usersRef = Database.database().reference(withPath: "online")
    let usersRefUpdate = Database.database().reference(withPath: "online/users")

    
    var databaseRef: DatabaseReference!
    
    var currentBestFriendCheck: NewFriendCheck!
    var user: User!
    var activeUsers = [ActiveUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donateInteraction()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        let lightGrey = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0).cgColor
        let lightBlue = UIColor(red: 208.0/255.0, green: 231.0/255.0, blue: 254.0/255.0, alpha: 1.0).cgColor
        gradient.colors = [lightGrey, lightBlue]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        
        
        checkInProgressView.layer.cornerRadius = 10
        checkInProgressView.isHidden = true
        //backgroundView.layer.addSublayer(gradient)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            print("update user ID")
            let userName = self.getUsersName()
            self.usersRefUpdate.ref.updateChildValues([
                userName: true
            ])
            if let userDefaults = UserDefaults(suiteName: "group.marklawrence.Best-Friend-Check-group-id") {
                userDefaults.set(user.uid as String, forKey: "userID")
                userDefaults.synchronize()
            }
            //let currentUserRef = self.usersRef.child(self.user.uid)
            //currentUserRef.setValue(self.user.uid)
            //currentUserRef.onDisconnectRemoveValue()
        }
            
       
        
        self.bestFriendCheckRef = Database.database().reference(withPath: "best-friend-checks")
        bestFriendCheckRef.observe(.value, with: { snapshot in
            var newItems: [NewFriendCheck] = []
            self.checkButton.isUserInteractionEnabled = true
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let friendItem = NewFriendCheck(snapshot: snapshot) {
                    newItems.append(friendItem)
                }
            }
            if newItems.count != 0{
                self.currentBestFriendCheck = newItems[0]
                let currentDate = Date().timeIntervalSince1970
                if (currentDate - self.currentBestFriendCheck.date) > 86400{
                    let expiredFriendCheck = newItems[0]
                    expiredFriendCheck.ref?.removeValue()
                    print("Expire check")
                    self.checkInProgressView.isHidden = true
                } else{
                    print("THIS IS RUNNING")
                    self.performSegue(withIdentifier: "friendCheckInProgress", sender: nil)
                }
            }
            //self.updateFriendUI()
            //self.tableView.reloadData()
        })
        
        usersRef.observe(.value, with: { snapshot in
            var newActiveUsers: [ActiveUser] = []
            if snapshot.exists() {
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let newUserOnline = ActiveUser(snapshot: snapshot) {
                        newActiveUsers.append(newUserOnline)
                    }
                }
                
            }
            self.activeUsers = newActiveUsers
            self.updateActiveFriendsUI()
        })
    }
    
    @IBAction func newBestFriendCheck(_ sender: Any) {
        let id = user.uid
        var userName = "";
        var bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "not sent", mark: false, justin: false, allison: false, nicole: false, ellie: false, molly: false)
        if (id == "wlec3D7PYZTGBJ1Xx4SxTkMcRVE2"){
            bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "wlec3D7PYZTGBJ1Xx4SxTkMcRVE2", mark: true, justin: false, allison: false, nicole: false, ellie: false, molly: false)
            userName = "Mark"
        } else if(id == "BZngmfcDMCZmxsX0HogN9bRSi1J2"){
            bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "BZngmfcDMCZmxsX0HogN9bRSi1J2", mark: false, justin: true, allison: false, nicole: false, ellie: false, molly: false)
            userName = "Justin"
        } else if(id == "JHa5y5nuTPSwJWXqqc49OPSKFhl1"){
            bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "JHa5y5nuTPSwJWXqqc49OPSKFhl1", mark: false, justin: false, allison: true, nicole: false, ellie: false, molly: false)
            userName = "Allison"
        } else if(id == "MQo1Bl3nYzYK7e8vHMRcQ88e0FU2"){
            bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "MQo1Bl3nYzYK7e8vHMRcQ88e0FU2", mark: false, justin: false, allison: false, nicole: true, ellie: false, molly: false)
            userName = "Nicole"
        } else if(id == "lq90H5TV4Rf1cofy5nwyisfAZrs2"){
            bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "lq90H5TV4Rf1cofy5nwyisfAZrs2", mark: false, justin: false, allison: false, nicole: false, ellie: true, molly: false)
            userName = "Ellie"
        } else if(id == "VCO1kUZIHjaQCziCcTDCPd83FNL2"){
            bestFriend = NewFriendCheck(date: Date().timeIntervalSince1970, sender: "VCO1kUZIHjaQCziCcTDCPd83FNL2", mark: false, justin: false, allison: false, nicole: false, ellie: false, molly: true)
            userName = "Molly"
        }
        
        databaseRef = Database.database().reference()
        databaseRef.child("notification/latestNotification").setValue(userName)
        
        let bestFriendRef = self.bestFriendCheckRef.child("new friend check")
        bestFriendRef.setValue(bestFriend.toAnyObject())
    }
    
    
    @IBAction func didTapViewCurrentFriendCheck(_ sender: Any) {
        self.performSegue(withIdentifier: "friendCheckInProgress", sender: nil)
    }
    
    func updateActiveFriendsUI() {
        for i in 0..<activeUsers.count{
            if (activeUsers[i].mark){
                markBackground.image = UIImage(named: "goldCircle")
            } else{
                markBackground.image = UIImage(named: "greyCircle")
            }
            if(activeUsers[i].justin){
                justinBackground.image = UIImage(named: "goldCircle")
            } else{
                justinBackground.image = UIImage(named: "greyCircle")
            }
            if(activeUsers[i].allison){
                allisonBackground.image = UIImage(named: "goldCircle")
            } else{
                allisonBackground.image = UIImage(named: "greyCircle")
            }
            if(activeUsers[i].nicole){
                nicoleBackground.image = UIImage(named: "goldCircle")
            } else{
                nicoleBackground.image = UIImage(named: "greyCircle")
            }
            if(activeUsers[i].ellie){
                ellieBackground.image = UIImage(named: "goldCircle")
            } else{
                ellieBackground.image = UIImage(named: "greyCircle")
            }
            if(activeUsers[i].molly){
                mollyBackground.image = UIImage(named: "goldCircle")
            } else{
                mollyBackground.image = UIImage(named: "greyCircle")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.titleLabel.alpha = 0.0
        })
        if segue.identifier == "friendCheckInProgress"{
            let checkVC = segue.destination as! CheckFriendsViewController
            checkVC.user = user
            checkVC.viewController = self
        }
    }
    
    @IBAction func unwindViewController(segue:UIStoryboardSegue) {
        let checkVC = segue.source as! CheckFriendsViewController
        let currentUser = checkVC.userWhoActivatedTheCheck
        
        checkInProgressView.isHidden = false
        checkInProgressLabel.text = "\(currentUser) sent out a Best Friend Check!"
        
        UIView.animate(withDuration: 0.5, animations: {
            self.titleLabel.alpha = 1.0
        })
    }
    
    func unwindFromPan(currentUser: String, expired: Bool){
        checkInProgressView.isHidden = false
        checkInProgressLabel.text = "\(currentUser) sent out a Best Friend Check!"
        
        
        if(expired){
            checkInProgressView.isHidden = true
        }
        print("Unwinding, animate text in")
        UIView.animate(withDuration: 0.5, animations: {
            self.titleLabel.alpha = 1.0
        })
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        let userName = getUsersName()
        usersRefUpdate.ref.updateChildValues([
            userName: false
            ])
        //let removedUserItem = activeUsers[findUsersIndex()]
        //removedUserItem.ref?.removeValue()
        //let groceryItem = items[indexPath.row]
        //groceryItem.ref?.removeValue()
    }
    
    
    @objc func appMovedToForeground(){
        let userName = getUsersName()
        usersRefUpdate.ref.updateChildValues([
            userName: true
            ])
        //print("App moved into foreground!")
        //let id = user.uid
        //var newUserOnline = ActiveUser(id: id)
        //let newOnlineRef = self.usersRef.child("id")
        //newOnlineRef.setValue(newUserOnline.toAnyObject())
    }
    
    func getUsersName() -> String{
        let id = user.uid
        var usersName = ""
        if (id == "wlec3D7PYZTGBJ1Xx4SxTkMcRVE2"){
            usersName = "mark"
        } else if(id == "BZngmfcDMCZmxsX0HogN9bRSi1J2"){
            usersName = "justin"
        } else if(id == "JHa5y5nuTPSwJWXqqc49OPSKFhl1"){
            usersName = "allison"
        } else if(id == "MQo1Bl3nYzYK7e8vHMRcQ88e0FU2"){
            usersName = "nicole"
        } else if(id == "lq90H5TV4Rf1cofy5nwyisfAZrs2"){
            usersName = "ellie"
        } else if(id == "VCO1kUZIHjaQCziCcTDCPd83FNL2"){
            usersName = "molly"
        }
        return usersName
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            do {
                try Auth.auth().signOut()
                print("Sign out")
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
    }
    
    func donateInteraction() {
        if #available(iOS 12.0, *) {
            let intent = NewFriendCheckIntent()
            
            intent.suggestedInvocationPhrase = "Best Friend Check!"
            
            let interaction = INInteraction(intent: intent, response: nil)
            
            interaction.donate { (error) in
                if error != nil {
                    if let error = error as NSError? {
                        //_log("Interaction donation failed: %@", log: OSLog.default, type: .error, error)
                    } else {
                       // _log("Successfully donated interaction")
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
}

