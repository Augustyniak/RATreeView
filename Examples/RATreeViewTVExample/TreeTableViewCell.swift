//
//  TreeTableViewCell.swift
//  RATreeViewExamples
//
//  Created by Rafal Augustyniak on 31/08/16.
//  Copyright © 2016 com.Augustyniak. All rights reserved.
//

import UIKit

class TreeTableViewCell : UITableViewCell {
    
    @IBOutlet private weak var customTitleLabel: UILabel!
    @IBOutlet weak var customTitleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        selectedBackgroundView? = UIView.init()
        selectedBackgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    var additionButtonActionBlock : (TreeTableViewCell -> Void)?;
    
    func setup(withTitle title: String, detailsText: String, level : Int) {
        customTitleLabel.text = title
        detailsLabel.text = detailsText
        self.backgroundView = UIView()
    
        var color: UIColor
        if level == 0 {
             color = UIColor.init(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 0.25)
        } else if level == 1 {
            color = UIColor.init(red: 209.0/255.0, green: 238.0/255.0, blue: 252.0/255.0, alpha: 0.25)
        } else {
            color = UIColor.init(red: 224.0/255.0, green: 248.0/255.0, blue: 216.0/255.0, alpha: 0.25)
        }
        
        self.backgroundView?.backgroundColor = color
        
        let left = 30 + 40 * CGFloat(level)
        self.customTitleLabelLeadingConstraint.constant = left
    }
    
    func additionButtonTapped(sender : AnyObject) -> Void {
        if let action = additionButtonActionBlock {
            action(self)
        }
    }
    
}
