//
//  CountryCellView.swift
//  CountryListUIKit
//
//  Created by Abouzar Moradian on 10/2/24.
//

import UIKit

class CountryCellView: UITableViewCell {
    
    var country: CountryModel! {
        didSet{
            nameLabel.text = country.name
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
