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
        colorName.translatesAutoresizingMaskIntoConstraints = false
        return colorName
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(colorName)
        colorName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        colorName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
