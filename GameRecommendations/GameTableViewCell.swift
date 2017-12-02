//
//  GameTableViewCell.swift
//  GameRecommendations
//
//  Created by David on 23/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell
{

    //MARK: Properties
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
