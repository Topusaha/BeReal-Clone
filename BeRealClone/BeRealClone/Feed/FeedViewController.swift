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
import UserNotifications

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                        self.feed.reloadData()
                }
        }
    }
    
    private let refreshControl = UIRefreshControl()
    
    
    private func queryPosts(completion: (() -> Void)? = nil) {
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!

        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate)
            .limit(10)
                           

        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .failure(let error):
                print(error.localizedDescription)
            }

            
            completion?()
        }
    }
    
    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        queryPosts { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        queryPosts()
        
        if #available(iOS 10.0, *) {
            feed.refreshControl = refreshControl
        } else {
            feed.addSubview(refreshControl)
        }
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
        checkForPremissions()
        
        feed.delegate = self
        feed.dataSource = self
        feed.allowsSelection = false

        feed.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }
    
    @IBAction func pressedLogOut(_ sender: Any) {
        disableNotifications()
        showConfirmLogoutAlert()
        

    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}


// for notifications methods
extension FeedViewController {
    
    func checkForPremissions() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings {settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            
            case .denied:
                print("denied")
            
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) {didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
                
            default:
                return
            }
        }
    }
    
    func dispatchNotification() {
        let id = "Daily Notification"
        let title: String = "Time to Post"
        let body: String = "Come see what your firsts are posting!"
        
        let hour = 12
        let minute = 01
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            } else {
                print("Notification request added successfully.")
                }
            }
    }
    
    func disableNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }
    
}



