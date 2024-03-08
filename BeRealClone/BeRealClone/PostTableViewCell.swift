//
//  PostTableViewCell.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/7/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var locationAndTime: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captain: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
