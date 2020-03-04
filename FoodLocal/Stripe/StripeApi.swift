//
//  StripeApi.swift
//  Artable
//
//  Created by Martin Parker on 08/01/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider{
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        let data = [
            "stripe_version": apiVersion,
            "customer_id": UserService.user.stripeId
        ]
        
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
             
            if let error = error{
                debugPrint(error.localizedDescription)
                completion(nil, error)
                return
            }
            guard let key = result?.data as? [String: Any] else{
                completion(nil, nil)
                return
            }
            completion(key, nil)
        }
        
    }
    
    
}
