//
//  FeedViewController.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/7/24.
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Post" // Replace with the actual identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        return cell
    }
    

   
    @IBOutlet weak var feed: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feed.delegate = self
        feed.dataSource = self

    }
    
    @IBAction func pressedLogOut(_ sender: Any) {
        
        User.logout { [weak self] result in
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let destinationVC = self?.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                    self?.present(destinationVC, animated: false, completion: nil)
                }
                           
            case .failure(let error):
                print("❌ Log out error: \(error)")
            }
            
        }
        
        
    }
    
    

}
