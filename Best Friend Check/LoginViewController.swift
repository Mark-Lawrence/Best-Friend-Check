
import UIKit
import Firebase
import IntentsUI

@available(iOS 12.0, *)
class LoginViewController: UIViewController, UITextFieldDelegate {

    
  
  // MARK: Constants
  let loginToList = "logIn"
    
    @IBOutlet weak var siriButtonView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var addToSiriText: UILabel!
    
    @IBOutlet weak var loadingView: UIView!
    
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  
    override func viewDidLoad() {
        //logInButton.isEnabled = false
        //logInButton.backgroundColor()
        super.viewDidLoad()
        self.textFieldLoginEmail.delegate = self
        addSiriButton(to: siriButtonView)
        Auth.auth().addStateDidChangeListener() { auth, user in
           
            if user != nil {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
                self.textFieldLoginEmail.text = nil
            }
            else{
                print("No login")
                self.loadingView.isHidden = true
                
            }
        }
    }
  
    @IBAction func didTapEnter(_ sender: Any) {
        textFieldLoginEmail.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
//    guard
//        let email = textFieldLoginEmail.text,
//        email.count > 0
//        else {
//            return
//    }
    
    let email = emailLookUp(inputText: textFieldLoginEmail.text!)
    
    
    
    Auth.auth().signIn(withEmail: email, password: "password") { user, error in
        if let error = error, user == nil {
            let alert = UIAlertController(title: "Sign In Failed",
                                          message: "Please enter your first and last name to continue",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
  }
    
    func emailLookUp(inputText: String) -> String{
        var email = ""
        
        if inputText == "Mark Lawrence"{
            email = "mark@bestfriend.com"
        } else if inputText == "Justin Lawrence"{
            email = "justin@bestfriend.com"
        } else if inputText == "Allison Lawrence"{
            email = "allison@bestfriend.com"
        } else if inputText == "Nicole Lawrence"{
            email = "nicole@bestfriend.com"
        } else if inputText == "Ellie Simmons"{
            email = "ellie@bestfriend.com"
        } else if inputText == "Molly Simmons"{
            email = "molly@bestfriend.com"
        }
        
        return email
    }
    
    func addSiriButton(to view: UIView) {
        let button = INUIAddVoiceShortcutButton(style: .whiteOutline)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.shortcut = INShortcut(intent: NewFriendCheckIntent())
        button.delegate = self
        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(button)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        
        //button.addTarget(self, action: #selector(addToSiri(_:)), for: .touchUpInside)
    }
    
    // Present the Add Shortcut view controller after the
    // user taps the "Add to Siri" button.
    
}

@available(iOS 12.0, *)
extension LoginViewController: INUIAddVoiceShortcutButtonDelegate {
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    /// - Tag: edit_phrase
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}

@available(iOS 12.0, *)
extension LoginViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?,
                                        error: Error?) {
        if let error = error as NSError? {
            //os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        logInButton.isEnabled = true
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
        logInButton.isEnabled = true
    }
}


@available(iOS 12.0, *)
extension LoginViewController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didUpdate voiceShortcut: INVoiceShortcut?,
                                         error: Error?) {
        if let error = error as NSError? {
            //os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        
        controller.dismiss(animated: true, completion: nil)

    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
 
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)

    }
}
