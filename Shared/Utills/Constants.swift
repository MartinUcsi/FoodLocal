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
    static let SellerLoginStoryboard = "SellerLoginStoryboard"
    static let RiderLoginStoryboard = "RiderLoginStoryboard"
}

struct StoryboardID {
    static let LoginVC = "loginVC"
    static let sellerloginVC = "SellerloginVC"
    static let RiderloginVC = "RiderloginVC"
}

struct AppImage {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    static let touchngoDetail = "touchngoDetail"
    static let maybankDetail = "maybankDetail"
    static let grabpayDetail = "grabpayDetail"
    static let boostDetail = "boostDetail"
    static let alipayDetail = "alipayDetail"
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
    static let backToCheckout = "backToCheckout"
    static let goToPaymentMethod = "goToPaymentMethod"
    static let OrderCell = "OrderCell"
    static let SellerCell = "SellerCell"
    static let SellerProductCell = "SellerProductCell"
    static let RiderOrderCell = "RiderOrderCell"
    static let UserOrderCell = "UserOrderCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let ToFavorites = "ToFavorites"
    static let ToAdminHomeVC = "ToAdminHomeVC"
    static let BackToLoginAdmin = "BackToLoginAdmin"
    static let toSellerProductsVC = "toSellerProductsVC"
    static let toAddSellerProductsVC = "toAddSellerProductsVC"
    static let AddSellerProductOnly = "AddSellerProductOnly"
    static let toAcceptOrderVC = "toAcceptOrderVC"
  
}
