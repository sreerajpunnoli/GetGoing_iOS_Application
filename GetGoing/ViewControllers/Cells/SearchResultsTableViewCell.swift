///Users/msccda/Desktop/Class Work/GetGoing/GetGoing/ViewControllers/Cells/SearchResultsTableViewCell.swift
//  SearchResultsTableViewCell.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-01-23.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var vicinityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var ratingControl: RatingContro!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
