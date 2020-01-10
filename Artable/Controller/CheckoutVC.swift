//
//  CheckoutVC.swift
//  Artable
//
//  Created by Martin Parker on 02/01/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Stripe

class CheckoutVC: UIViewController, CartItemDelegate {
  
    

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var processingFeeLbl: UILabel!
    @IBOutlet weak var shippingCostLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Variables
    var paymentContext: STPPaymentContext!
    var nickName : String!
    var apt : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPaymentInfo()
        setupStripeConfig()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.CartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.CartItemCell)
    }

    func setupPaymentInfo(){
        subtotalLbl.text = StripeCart.subtotal.penniesToFormattedCurrency()
        processingFeeLbl.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingCostLbl.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLbl.text = StripeCart.total.penniesToFormattedCurrency()
    }
    
    func setupStripeConfig(){
        let config = STPPaymentConfiguration.shared()
        config.createCardSources = true
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress, .name, .phoneNumber]
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        
        
        
        
    }
    
    
    
    @IBAction func placeOrderClicked(_ sender: Any) {
//        simpleAlert(title: "CartItem", msg: "\(StripeCart.cartItems.count)")
//        let orderName = StripeCart.cartItems.filter { $0.name == "Chinese Crepe" }
//        print(orderName)
       // print(StripeCart.cartItems)
        var itemArray = [String]()
        for item in StripeCart.cartItems.count {
            //print(item)
            //print("\(StripeCart.cartItems[item].name)")
            itemArray.append(StripeCart.cartItems[item].name)
        }
        
        simpleAlert(title: "CartItem", msg: "\(itemArray)")
        
//        paymentContext.requestPayment()
//        activityIndicator.startAnimating()
        
    }
    @IBAction func paymentMethodClicked(_ sender: Any) {
        
        paymentContext.pushPaymentOptionsViewController()
        
        
    }
    @IBAction func shippingMethodClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
    
    func removeItem(product: Product) {
        StripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        setupPaymentInfo()
        paymentContext.paymentAmount = StripeCart.total
      }

}

extension CheckoutVC : STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        // Updating the selected payment method
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodBtn.setTitle( paymentMethod.label ,for: .normal)
        } else{
            paymentMethodBtn.setTitle("Select Method", for: .normal)
        }
        
        // Updating the selected shipping method
        if let shippingMethod = paymentContext.selectedShippingMethod {
            shippingMethodBtn.setTitle(shippingMethod.label, for: .normal)
            StripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100)
            setupPaymentInfo()
        }else{
            shippingMethodBtn.setTitle("Select", for: .normal)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: "You must login in before making purchases.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let login = UIAlertAction(title: "Login", style: .default) { (action) in
            let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard , bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
            self.present(controller, animated: true, completion: nil)
        }
        
        alertController.addAction(cancel)
        alertController.addAction(login)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
         
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrive in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        let fedEx = PKShippingMethod()
        fedEx.amount = 6.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrive tomorrow"
        fedEx.identifier = "fedex"
        
        if address.postalCode == "56000" {
            completion(.valid, nil, [upsGround, fedEx], fedEx)
            apt = "\(address.line2)"
        }else {
            completion(.invalid, nil, nil, nil)
        }
        
    }
     
}

extension CheckoutVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemCell, for: indexPath) as? CartItemCell {
            
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}
