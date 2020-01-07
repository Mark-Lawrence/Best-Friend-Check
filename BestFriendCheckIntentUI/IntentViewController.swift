//
//  IntentViewController.swift
//  BestFriendCheckIntentUI
//
//  Created by Mark Lawrence on 11/30/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var alertBackgroundView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        let width = self.extensionContext?.hostedViewMaximumAllowedSize.width ?? 320
        let desiredSize = CGSize(width: width, height: 150)
        
        let newGradient = CAGradientLayer()
        newGradient.frame = CGRect(x: 0, y: 0, width: width, height: 150)
        let lightGrey = UIColor(red: 66.0/255.0, green: 228.0/255.0, blue: 234.0/255.0, alpha: 1.0).cgColor
        let lightBlue = UIColor(red: 140.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0).cgColor
        newGradient.colors = [lightGrey, lightBlue]
        alertBackgroundView.layer.addSublayer(newGradient)
        alertBackgroundView.layer.cornerRadius = 10
        
        var userID = "test"
        if let userDefaults = UserDefaults(suiteName: "group.marklawrence.Best-Friend-Check-group-id") {
            userID = userDefaults.string(forKey: "userID")!
        }
        
        if (userID == "wlec3D7PYZTGBJ1Xx4SxTkMcRVE2"){
            userProfile.image = UIImage(named: "Mark")
        } else if(userID == "BZngmfcDMCZmxsX0HogN9bRSi1J2"){
            userProfile.image = UIImage(named: "Justin")
        } else if(userID == "JHa5y5nuTPSwJWXqqc49OPSKFhl1"){
            userProfile.image = UIImage(named: "Allison")
        } else if(userID == "MQo1Bl3nYzYK7e8vHMRcQ88e0FU2"){
            userProfile.image = UIImage(named: "Nicole")
        } else if(userID == "lq90H5TV4Rf1cofy5nwyisfAZrs2"){
            userProfile.image = UIImage(named: "Ellie")
        } else if(userID == "VCO1kUZIHjaQCziCcTDCPd83FNL2"){
            userProfile.image = UIImage(named: "Molly")
        }
        
        
        completion(true, parameters, desiredSize)
    }

    
}
