//
//  CountryShortCell.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import UIKit

class CountryShortCell: UITableViewCell, TableCellProtocol {
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryNativeName: UILabel!
    @IBOutlet weak var countryPopulation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
    
    func configureWithModel(model: TableRawProtocol, animated:Bool) {
        guard let m = model as? CountryShortRow else {
            return
        }
        
        countryName.text = m.name
        countryNativeName.text = m.nativeName
        countryPopulation.text = m.populationText
    }
}
