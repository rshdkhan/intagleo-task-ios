//
//  HomeTableViewCell.swift
//  Task
//
//  Created by Rashid Khan on 3/1/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(item: Item) {
        self.lblTitle.text = item.title
    }
}
