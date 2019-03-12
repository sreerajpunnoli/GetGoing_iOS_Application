//
//  RatingContro.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-01-28.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import UIKit

class RatingContro: UIStackView {
    
    // Mark: - Properties
    var stars = [UIButton]()
    
    var rating: Int = 0 {
        didSet {
            updateRating()
        }
    }
    
    // Mark: - Initializers
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // Mark: - Methods
    
    func updateRating() {
        for (index, star) in stars.enumerated() {
            star.isSelected = index < rating
        }
    }
    
    private func setupButtons() {
        //for star in stars {
        
        let filledStar = UIImage(named: "StarFull")
        let emptyStar = UIImage(named: "StarEmpty")
        
        for _ in 0..<5 {
            
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            let buttonSize:CGFloat = 44.0
            button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            
            addArrangedSubview(button)
            stars.append(button)
        }
        
    }
    
}

//}
