//
//  HomeActionItemTableViewCell.swift
//  TestUIApp
//
//  Created by Ryan Helgeson on 7/8/23.
//

import UIKit

class HomeActionItemTableViewCell: UITableViewCell {
    static let identifier = "HomeActionItemTableViewCell"
    // MARK: - UI Elements
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var item: HomeActionItem? {
        didSet {
            configure()
        }
    }
   
    // MARK: - Configure
    func configure() {
        if let item = item {
            iconImageView.image = UIImage(systemName: item.image)
            label.text = item.title
        }
    }
    
    
}
