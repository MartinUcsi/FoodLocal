//
//  StripeCart.swift
//  Artable
//
//  Created by Martin Parker on 02/01/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation


let StripeCart = _StripeCart()

final class _StripeCart {
    
    var cartItems = [Product]()
    private let stripeCreditCardCut = 0.034
    private let flatFeeCents = 30
    
    //var shippingFees = 500
    var shippingFees = 0
    
    
    // Variable for subtotal, processing fees, total, shippingFees
    
//
//    var shippingFees: Int {
//        var amount = 500
//        if cartItems.count > 4 {
//            amount += 100
//        }
//
//
//        return amount
//    }
    
    var subtotal: Int {
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    
    
    var processingFees : Int {
        
        if subtotal == 0 {
            return 0
        }
        
        let sub = Double(subtotal)
        let feesAndSub = Int(sub * stripeCreditCardCut) + flatFeeCents
        return feesAndSub
    }
    
    var total : Int {
        return subtotal + processingFees + shippingFees
    }
 
    func addItemToCart(item: Product) {
        cartItems.append(item)
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
}
