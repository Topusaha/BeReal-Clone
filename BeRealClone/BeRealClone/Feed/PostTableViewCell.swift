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
