//
//  DropboxListingCell.swift
//  SwiftyDropDataListing
//
//  Created by Sahil on 27/09/16.
//  Copyright © 2016 SammyOne. All rights reserved.
//

import UIKit

class DropboxListingCell: UITableViewCell {
  
  
   var listImageView: UIImageView = UIImageView()
   var fileName: UILabel = UILabel()
  
  override func awakeFromNib() {
    
    super.awakeFromNib()
    // Initialization code
  }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(listImageView)
        self.contentView.addSubview(fileName)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        listImageView.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        fileName.frame = CGRect(x: (listImageView.frame.origin.x + listImageView.frame.size.width + 10), y: 10, width: UIScreen.main.bounds.size.width-65, height: 30)
    }
  
}
