//
//  CategoryCell.swift
//  CocktailApp
//
//  Created by Ensar on 25.12.2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    static let identifier = "CategoryCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // label
        label.contentMode = .center
    }
}
