//
//  CheckFriendsViewController.swift
//  Best Friend Check
//
//  Created by Mark Lawrence on 11/26/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit
import Firebase

class CheckFriendsViewController: UIViewController {

    @IBOutlet weak var currentFriendAvator: UIImageView!
    @IBOutlet weak var currentFriendText: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    
    @IBOutlet weak var markBackground: UIImageView!
    @IBOutlet weak var nicoleBackground: UIImageView!
    @IBOutlet weak var mollyBackground: UIImageView!
    @IBOutlet weak var allisonBackground: UIImageView!
    @IBOutlet weak var ellieBackground: UIImageView!
    @IBOutlet weak var justinBackground: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    var viewController: ViewController!
    
     var databaseRef: DatabaseReference!
    var bestFriendCheckRef: DatabaseReference!
    var currentBestFriendCheck: NewFriendCheck!
    var user: User!
    var userWhoActivatedTheCheck = ""

    var gradient = CAGradientLayer()
    let screenSize = UIScreen.main.bounds
    
    let emitterLayer = CAEmitterLayer()
    
    var firstTimeExire = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBaseLayer()
        //launchFireworks()
        
        backgroundView.layer.cornerRadius = 10
        
        gradient.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        let lightGrey = UIColor(red: 66.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 1.0).cgColor
        let lightBlue = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0).cgColor
        gradient.colors = [lightGrey, lightBlue]
        //gradient.startPoint = CGPoint(x: 1, y: 0)
        //gradient.endPoint = CGPoint(x: 0, y: 1)
        
        backgroundView.layer.addSublayer(gradient)
        
        
        self.bestFriendCheckRef = Database.database().reference(withPath: "best-friend-checks")
        bestFriendCheckRef.observe(.value, with: { snapshot in
            var newItems: [NewFriendCheck] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let friendItem = NewFriendCheck(snapshot: snapshot) {
                    newItems.append(friendItem)
                }
            }
            if newItems.count != 0{
                
                self.currentBestFriendCheck = newItems[0]
                let currentDate = Date().timeIntervalSince1970
                print("EXPIRE TIME \(self.currentBestFriendCheck.date)")
                
                self.updateTheUIForTheSender(id: newItems[0].sender)
                self.currentBestFriendCheck = newItems[0]
                self.updateCheckedOffUI()
                self.checkIfEveryoneHasCheckedIn()
                
                if (currentDate - self.currentBestFriendCheck.date) > 86400{
                    let expiredFriendCheck = newItems[0]
                    expiredFriendCheck.ref?.removeValue()
                    print("Expire check")
                    self.firstTimeExire = true
                    self.dismiss(animated: true, completion: nil)
                    self.viewController.unwindFromPan(currentUser: self.userWhoActivatedTheCheck, expired: true)
                }
            }
        })
    }
    
    @IBAction func didTapCheckButton(_ sender: Any) {
        //checkButton.setImage(UIImage(named: "Green check"), for: .normal)
        currentBestFriendCheck.ref?.updateChildValues([
            getUsersName(): true
            ])
    }
    
    
    func updateTheUIForTheSender(id: String) {
        if (id == "wlec3D7PYZTGBJ1Xx4SxTkMcRVE2"){
            currentFriendAvator.image = UIImage(named: "Mark")
            userWhoActivatedTheCheck = "Mark"
            currentFriendText.text = "Mark Sent a Best Friend Check!"
        } else if(id == "BZngmfcDMCZmxsX0HogN9bRSi1J2"){
            currentFriendText.text = "Justin Sent a Best Friend Check!"
            currentFriendAvator.image = UIImage(named: "Justin")
            userWhoActivatedTheCheck = "Justin"
        } else if(id == "JHa5y5nuTPSwJWXqqc49OPSKFhl1"){
            currentFriendText.text = "Allison Sent a Best Friend Check!"
            currentFriendAvator.image = UIImage(named: "Allison")
            userWhoActivatedTheCheck = "Allison"
        } else if(id == "MQo1Bl3nYzYK7e8vHMRcQ88e0FU2"){
            currentFriendText.text = "Nicole Sent a Best Friend Check!"
            currentFriendAvator.image = UIImage(named: "Nicole")
            userWhoActivatedTheCheck = "Nicole"
        } else if(id == "lq90H5TV4Rf1cofy5nwyisfAZrs2"){
            currentFriendText.text = "Ellie Sent a Best Friend Check!"
            currentFriendAvator.image = UIImage(named: "Ellie")
            userWhoActivatedTheCheck = "Ellie"
        } else if(id == "VCO1kUZIHjaQCziCcTDCPd83FNL2"){
            currentFriendText.text = "Molly Sent a Best Friend Check!"
            currentFriendAvator.image = UIImage(named: "Molly")
            userWhoActivatedTheCheck = "Molly"
        }
    }
    
    func updateCheckedOffUI(){
        if currentBestFriendCheck.mark{
            markBackground.image = UIImage(named:"greenCircle")
        } else{
            markBackground.image = UIImage(named:"greyCircle")
        } 
        if currentBestFriendCheck.justin{
            justinBackground.image = UIImage(named:"greenCircle")
        }else{
            justinBackground.image = UIImage(named:"greyCircle")
        }
        if currentBestFriendCheck.allison{
            allisonBackground.image = UIImage(named:"greenCircle")
        } else{
            allisonBackground.image = UIImage(named:"greyCircle")
        }
        if currentBestFriendCheck.nicole{
            nicoleBackground.image = UIImage(named:"greenCircle")
        } else{
            nicoleBackground.image = UIImage(named:"greyCircle")
        }
        if currentBestFriendCheck.ellie{
            ellieBackground.image = UIImage(named:"greenCircle")
        } else{
            ellieBackground.image = UIImage(named:"greyCircle")
        }
        if currentBestFriendCheck.molly{
            mollyBackground.image = UIImage(named:"greenCircle")
        } else{
            mollyBackground.image = UIImage(named:"greyCircle")
        }
        
        let currentUser = getUsersName()
        if currentUser == "mark"{
            if currentBestFriendCheck.mark{
                checkButton.setImage(UIImage(named: "Green check"), for: .normal)
            } else{
                checkButton.setImage(UIImage(named: "white check"), for: .normal)
            }
        }else if currentUser == "justin"{
            if currentBestFriendCheck.justin{
                checkButton.setImage(UIImage(named: "Green check"), for: .normal)
            } else{
                checkButton.setImage(UIImage(named: "white check"), for: .normal)
            }
        } else if currentUser == "allison"{
            if currentBestFriendCheck.allison{
                checkButton.setImage(UIImage(named: "Green check"), for: .normal)
            } else{
                checkButton.setImage(UIImage(named: "white check"), for: .normal)
            }
        } else if currentUser == "nicole"{
            if currentBestFriendCheck.nicole{
                checkButton.setImage(UIImage(named: "Green check"), for: .normal)
            } else{
                checkButton.setImage(UIImage(named: "white check"), for: .normal)
            }
        } else if currentUser == "ellie"{
            if currentBestFriendCheck.ellie{
                checkButton.setImage(UIImage(named: "Green check"), for: .normal)
            } else{
                checkButton.setImage(UIImage(named: "white check"), for: .normal)
            }
        } else if currentUser == "molly"{
            if currentBestFriendCheck.molly{
                checkButton.setImage(UIImage(named: "Green check"), for: .normal)
            } else{
                checkButton.setImage(UIImage(named: "white check"), for: .normal)
            }
        }
    }
    
    func checkIfEveryoneHasCheckedIn(){
        var everyoneHasCheckedIn = true
        if !currentBestFriendCheck.mark{
            everyoneHasCheckedIn = false
        } else if !currentBestFriendCheck.justin{
            everyoneHasCheckedIn = false
        } else if !currentBestFriendCheck.allison{
            everyoneHasCheckedIn = false
        } else if !currentBestFriendCheck.nicole{
            everyoneHasCheckedIn = false
        } else if !currentBestFriendCheck.ellie{
            everyoneHasCheckedIn = false
        } else if !currentBestFriendCheck.molly{
            everyoneHasCheckedIn = false
        }
        if everyoneHasCheckedIn{
            let newGradient = CAGradientLayer()
            newGradient.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
          
            databaseRef = Database.database().reference()
            databaseRef.child("notification/latestNotification").setValue("Everyone")
            
            
            let lightGrey = UIColor(red: 72.0/255.0, green: 233.0/255.0, blue: 118.0/255.0, alpha: 1.0).cgColor
            let lightBlue = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0).cgColor
            newGradient.colors = [lightGrey, lightBlue]
            //gradient.startPoint = CGPoint(x: 1, y: 0)
            //gradient.endPoint = CGPoint(x: 0, y: 1)
            backgroundView.layer.replaceSublayer(gradient, with: newGradient)
            gradient = newGradient
            currentFriendText.text = "Everyone has checked in!"
            if firstTimeExire{
                let currentDate = Date().timeIntervalSince1970
                currentBestFriendCheck.ref?.updateChildValues([
                    "date": (currentDate - 86100)                    
                    ])
                firstTimeExire = false
            }

            
            //backgroundView.layer.addSublayer(gradient)
        } else{
            let newGradient = CAGradientLayer()
            newGradient.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            let lightGrey = UIColor(red: 66.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 1.0).cgColor
            let lightBlue = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0).cgColor
            newGradient.colors = [lightGrey, lightBlue]
            //gradient.startPoint = CGPoint(x: 1, y: 0)
            //gradient.endPoint = CGPoint(x: 0, y: 1)
            backgroundView.layer.replaceSublayer(gradient, with: newGradient)
            gradient = newGradient
        }
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
    
    var initialToucnPoint : CGPoint = CGPoint(x: 0, y: 0)
    
    @IBAction func panSeachAway(_ sender: UIPanGestureRecognizer) {
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)
        
        if (sender as AnyObject).state == UIGestureRecognizer.State.began{
            initialToucnPoint = touchPoint
        }
        else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialToucnPoint.y > 0 {
                //self.downButton.setImage(UIImage(named: "Flat Bar"), for: .normal)
                
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialToucnPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
        else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialToucnPoint.y > 200 {
                self.dismiss(animated: true, completion: nil)
                
                viewController.unwindFromPan(currentUser: userWhoActivatedTheCheck, expired: false)
                //self.searchTextFeild.resignFirstResponder()
                UIView.animate(withDuration: 0.2, animations: {
                    //self.parksVC.darkenBackground.alpha = 0.0
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    //self.downButton.setImage(UIImage(named: "Down Bar"), for: .normal)
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
        
    }
    
    func setupBaseLayer()
    {
        // Add a layer that emits, animates, and renders a particle system.
        let size = view.bounds.size
        emitterLayer.emitterPosition = CGPoint(x: size.width / 2, y: size.height - 100)
        emitterLayer.renderMode = CAEmitterLayerRenderMode.additive
        view.layer.addSublayer(emitterLayer)
    }
    
    
    func launchFireworks()
    {
        // Get particle image
        let particleImage = UIImage(named: "particle")?.cgImage
        
        // The definition of a particle (launch point of the firework)
        let baseCell = CAEmitterCell()
        baseCell.color = UIColor.white.withAlphaComponent(0.8).cgColor
        baseCell.emissionLongitude = -CGFloat.pi / 2
        baseCell.emissionRange = CGFloat.pi / 5
        baseCell.emissionLatitude = 0
        baseCell.lifetime = 2.0
        baseCell.birthRate = 1
        baseCell.velocity = 400
        baseCell.velocityRange = 50
        baseCell.yAcceleration = 300
        baseCell.redRange   = 0.5
        baseCell.greenRange = 0.5
        baseCell.blueRange  = 0.5
        baseCell.alphaRange = 0.5
        
        // The definition of a particle (rising animation)
        let risingCell = CAEmitterCell()
        risingCell.contents = particleImage
        risingCell.emissionLongitude = (4 * CGFloat.pi) / 2
        risingCell.emissionRange = CGFloat.pi / 7
        risingCell.scale = 0.4
        risingCell.velocity = 100
        risingCell.birthRate = 50
        risingCell.lifetime = 1.5
        risingCell.yAcceleration = 350
        risingCell.alphaSpeed = -0.7
        risingCell.scaleSpeed = -0.1
        risingCell.scaleRange = 0.1
        risingCell.beginTime = 0.01
        risingCell.duration = 0.7
        
        // The definition of a particle (spark animation)
        let sparkCell = CAEmitterCell()
        sparkCell.contents = particleImage
        sparkCell.emissionRange = 2 * CGFloat.pi
        sparkCell.birthRate = 8000
        sparkCell.scale = 0.5
        sparkCell.velocity = 130
        sparkCell.lifetime = 3.0
        sparkCell.yAcceleration = 80
        sparkCell.beginTime = 1.5
        sparkCell.duration = 0.1
        sparkCell.alphaSpeed = -0.1
        sparkCell.scaleSpeed = -0.1
        
        // baseCell contains rising and spark particle with animation
        baseCell.emitterCells = [risingCell, sparkCell]
        
        // Add baseCell to the emitter layer
        emitterLayer.emitterCells = [baseCell]
        //emitterLayer.emitterCells = []
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
