//
//  TableViewCell.swift
//  CourseProject
//
//  Created by Artem Manyshev on 27.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var colorName: UILabel = {
        let colorName = UILabel()
        colorName.textColor = .black
        colorName.font = colorName.font.withSize(15)
        return colorName
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setConstraintsOn(view: colorName, parantView: self, centeringxConstant: 0, centeringyConstant: 0)
    }
}
