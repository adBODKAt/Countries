//
//  InfoCell.swift
//  Countries
//
//  Created by Александр Марков on 27/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell, TableCellProtocol {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
    func configureWithModel(model: TableRawProtocol, animated:Bool) {
        guard let m = model as? InfoRow else {
            return
        }
        
        cellTitle.text = m.title
        cellValue.text = m.info
    }
}
