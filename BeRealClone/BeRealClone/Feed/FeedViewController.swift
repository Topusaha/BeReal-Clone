//
//  FeedViewController.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/7/24.
//

import UIKit
import ParseSwift
import Alamofire
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                        self.feed.reloadData()
                    }
        }
    }
    
    func queryPosts() {
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])

        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        queryPosts()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    
    

   
    @IBOutlet weak var feed: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feed.delegate = self
        feed.dataSource = self
        feed.allowsSelection = false


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



