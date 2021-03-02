//
//  HomeTableViewCell.swift
//  Task
//
//  Created by Rashid Khan on 3/1/21.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgThumbnail.cornerRadius = 17.5
    }

    func setup(item: Item) {
        self.imgThumbnail.sd_setImage(with: URL(string: item.thumbnailUrl ?? ""), placeholderImage: UIImage(systemName: "person.circle.fill"))
        self.lblTitle.text = item.title
    }
}
