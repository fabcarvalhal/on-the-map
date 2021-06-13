//
//  StudenLocationCell.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 13/06/21.
//

import UIKit

class StudentLocationCell: UITableViewCell {
    
    @IBOutlet private weak var pinImageView: UIImageView!
    @IBOutlet weak var cellTitlelabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func setData(title: String, subtitle: String) {
        cellTitlelabel.text = title
        subtitleLabel.text = subtitle
    }
}
