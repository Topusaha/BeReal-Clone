//
//  PostTableViewCell.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/7/24.
//

import UIKit
import Alamofire

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var locationAndDate: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captain: UILabel!
    
    private var imageDataRequest: DataRequest?
    @IBOutlet private weak var blurView: UIVisualEffectView!

    
    
    func configure(with post: Post) {
        if let user = post.user {
            name.text = user.username
        }
        
        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImage.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
            
            
             
            // TODO: Pt 2 - Show/hide blur view
            if let currentUser = User.current,

                // Get the date the user last shared a post (cast to Date).
               let lastPostedDate = currentUser.lastPostedDate,

                // Get the date the given post was created.
               let postCreatedDate = post.createdAt,

                // Get the difference in hours between when the given post was created and the current user last posted.
               let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {

                // Hide the blur view if the given post was created within 24 hours of the current user's last post. (before or after)
                blurView.isHidden = lastPostedDate != Date()
                
            } else {

                // Default to blur if we can't get or compute the date's above for some reason.
                blurView.isHidden = false
            }
            
        }
        
        self.captain.text = post.captain
        if let date = post.createdAt {
            self.locationAndDate.text = DateFormatter.postFormatter.string(from: date)
        }
    }
    
    override func prepareForReuse() {
        postImage.image = nil
        imageDataRequest?.cancel()
    }
}
