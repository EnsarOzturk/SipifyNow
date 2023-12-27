//
//  ListCell.swift
//  CocktailApp
//
//  Created by Ensar on 25.12.2023.
//

import UIKit
import SDWebImage

class ListCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var view: UIView!
    static let identifier = "ListCell"
  
    func configure(drink: Drink) {
        imageView.setImage(with: drink.strDrinkThumb)
        label.text = drink.strDrink
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.systemGray6
        // label
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont(name: "Copperplate", size: 15)
        // imageView
        imageView.layer.cornerRadius = 4
        
        // view
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.systemGray5
        
        // cell
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 4
    }
}

