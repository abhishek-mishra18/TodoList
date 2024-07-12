//
//  MyTableViewCell.swift
//  TodoList
//
//  Created by Abhishek on 12/07/24.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var createdAt: UILabel!
    
    @IBOutlet weak var myDescription: UILabel!
    
    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        title.numberOfLines = 0
        createdAt.numberOfLines = 0
        myDescription.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
