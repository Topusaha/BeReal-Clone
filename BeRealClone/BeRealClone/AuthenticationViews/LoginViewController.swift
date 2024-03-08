//
//  LoginViewController.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/7/24.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var logInUsername: UITextField!
    @IBOutlet weak var logInPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func pressedLoggedIn(_ sender: Any) {
        
        var username = logInUsername.text!
        var password = logInPassword.text!
        
        User.login(username: username, password: password) { [weak self] result in

            switch result {
            case .success(let user):
                print("✅ Successfully logged in as user: \(user)")

                // Post a notification that the user has successfully logged in.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                
                let destinationVC = self?.storyboard?.instantiateViewController(withIdentifier: "Home") as! FeedViewController
                self?.present(destinationVC, animated: false, completion: nil)

            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(description: String) {
            let alertController = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
        }

    

}
