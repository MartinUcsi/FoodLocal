//
//  Constants.swift
//  Artable
//
//  Created by Martin Parker on 10/12/2019.
//  Copyright © 2019 Martin Parker. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}

struct StoryboardID {
    static let LoginVC = "loginVC"

}

struct AppImage {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    
    
}

struct AppColors {
    static let blue = #colorLiteral(red: 0, green: 0.1254901961, blue: 0.2470588235, alpha: 0.83)
    static let red = #colorLiteral(red: 0.7961258562, green: 0.2426632168, blue: 0.1882352941, alpha: 0.85)
    static let offWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
    static let CartItemCell = "CartItemCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let ToFavorites = "ToFavorites"
}
