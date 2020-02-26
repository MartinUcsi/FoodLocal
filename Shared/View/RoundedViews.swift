//
//  RoundedViews.swift
//  Artable
//
//  Created by Martin Parker on 11/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import UIKit

class RoundedButton : UIButton {
   override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

class RoundedShadowView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = AppColors.blue.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class GrayShadowView : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
       
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.6
    }
}


class RoundedGrayShadowView : UIView{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.cornerRadius = 0
        
    }
}

class GrayTabBarView : UITabBar{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.cornerRadius = 0
        
    }
}

class RoundedGrayShadowStackView : UIStackView{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.cornerRadius = 5
        
    }
}



class RoundedGrayImageView : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 1.0
    }
}

class RoundedImageView : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}


class RoundedLabelView : UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}



