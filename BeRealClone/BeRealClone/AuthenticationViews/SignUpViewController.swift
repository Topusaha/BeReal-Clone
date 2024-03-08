//
//  SignUpViewController.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/7/24.
//

import UIKit
import ParseSwift

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var signUpUsername: UITextField!
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    private func showAlert(description: String) {
            let alertController = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
        }
    
    @IBAction func pressedSignedUp(_ sender: Any) {
        
        var newUser = User()
        newUser.username = signUpUsername.text
        newUser.email = signUpEmail.text
        newUser.password = signUpPassword.text
        
        newUser.signup { [weak self] result in
            
            switch result {
            case .success(let user):
                
                print("✅ Successfully signed up user \(user)")
                
                // Post a notification that the user has successfully signed up.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                

                
            case .failure(let error):
                // Failed sign up
                self?.showAlert(description: error.localizedDescription)
                


            }
        }
        
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(destinationVC, animated: true, completion: nil)
        
    }
    
    
}
