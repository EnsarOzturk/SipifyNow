//
//  SmallCardCell.swift
//  CocktailApp
//
//  Created by Ensar on 27.12.2023.
//

import UIKit
import SDWebImage

final class SmallCardCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var view: UIView!
    
    struct Constants {
        static let borderWidth: Double = 0.5
        static let cornerRadius: Double = 2.0
    }
    
    func configure(with cocktail: Cocktail) {
        imageView.setImage(with: cocktail.strDrinkThumb)
        label.text = cocktail.strDrink
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateUI() // UI'yi tekrar düzenle
        }
    }

    
    private func updateUI() {
        // Label
        label.textAlignment = .center
        label.textColor = .customTextColor // Dinamik text rengi
        label.numberOfLines = 0
        
        // Cell
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = UIColor.customBorderColor.cgColor // Dinamik border rengi
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = .customBackgroundColor // Arka plan rengi
    }
}
