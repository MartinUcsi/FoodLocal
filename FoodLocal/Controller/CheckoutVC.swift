//
//  CheckoutVC.swift
//  Artable
//
//  Created by Martin Parker on 02/01/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import FirebaseFirestore
class CheckoutVC: UIViewController, CartItemDelegate{
    
  
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
    var addressInfoArray = [String]()
    var amount = 0.0
    var selectedPaymentMethod : String =  ""
    var addressLine1 : String  = "Selected"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPaymentInfo()
        setupStripeConfig()
       
       self.navigationController?.setNavigationBarHidden(false, animated:false)

//        //Create back button of type custom
//
        let myBackButton:UIButton = UIButton.init(type: .custom)
        myBackButton.addTarget(self, action: #selector(CheckoutVC.popToRoot(sender:)), for: .touchUpInside)
        myBackButton.setTitle("Back", for: .normal)
        myBackButton.setTitleColor(.white, for: .normal)
        myBackButton.sizeToFit()
//
//       //Add back button to navigationBar as left Button

        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(selectedPaymentMethod)
    }
    @objc func popToRoot(sender:UIBarButtonItem){
        _ = self.navigationController?.popToRootViewController(animated: true)
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
    
   
      
    
    
    // MARK: Place Order Clicked
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        //        let orderName = StripeCart.cartItems.filter { $0.name == "Chinese Crepe" }
        
        if StripeCart.cartItems.count == 0 {
            simpleAlert(title: "Error", msg: "There is nothing inside the cart!")
        }else if addressInfoArray.isEmpty == true {
            simpleAlert(title: "Error", msg: "Please fill in the delivery address!")
        }else if selectedPaymentMethod == ""{
            simpleAlert(title: "Error", msg: "Please selected the payment method")
        }else{
            
            var itemArray = [String]()
            for item in StripeCart.cartItems.count {
                //print(item)
                //print("\(StripeCart.cartItems[item].name)")
                itemArray.append("\(StripeCart.cartItems[item].name) , X 1")
            }

            activityIndicator.startAnimating()
            // Variable
            let userId = Auth.auth().currentUser?.uid
            let totalAmount: Double = (Double(StripeCart.total))/100
            let CustomerName = addressInfoArray[0]
            let PhoneNumber = addressInfoArray[1]
            let LineOne = addressInfoArray[2]
            let LineTwo = addressInfoArray[3]
            
            //print(totalAmount)
            //upload document
            var docRef: DocumentReference!
            docRef = Firestore.firestore().collection("order").document()
            //        let order = Order.init(id: userId!,
            //                               amount: totalAmount,
            //                               customerName: CustomerName,
            //                               item: itemArray)
            // print(docRef.documentID)
            let order = Order.init(id: docRef.documentID,
                                   customerId: userId!,
                                   amount: totalAmount,
                                   customerName: CustomerName,
                                   phoneNumber: PhoneNumber,
                                   lineOne: LineOne,
                                   lineTwo: LineTwo,
                                   paymentMethod: selectedPaymentMethod,
                                   item: itemArray)
            
            
            
            
            let data = Order.modelToData(order: order)
            docRef.setData(data, merge: true) { (error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to upload new order to firestore")
                    return
                }
                self.activityIndicator.stopAnimating()
                
                let alertController = UIAlertController(title: "Sucess", message: "Order Created!", preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    //                let OrderVC = self.storyboard?.instantiateViewController(identifier: StoryboardID.OrderScreen) as! UserOrderVC
                    //
                    //                self.present(OrderVC, animated: true, completion: nil)
                    //
                    StripeCart.clearCart()
                    self.tableView.reloadData()
                    self.setupPaymentInfo()
                }
                alertController.addAction(OK)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    func handleError(error: Error, msg: String){
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }
    @IBAction func paymentMethodClicked(_ sender: Any) {
        
        //paymentContext.pushPaymentOptionsViewController()
        performSegue(withIdentifier: Identifiers.goToPaymentMethod, sender: self)
      
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
//        if let paymentMethod = paymentContext.selectedPaymentOption {
//            //paymentMethodBtn.setTitle( "\(selectedPaymentMethod)" ,for: .normal)
//            paymentMethodBtn.setTitle( "Please Selected" ,for: .normal)
//
//        } else{
//            paymentMethodBtn.setTitle("Select Method", for: .normal)
//        }
//
        if selectedPaymentMethod == "" {
            paymentMethodBtn.setTitle("Select Method", for: .normal)
        }else{
            paymentMethodBtn.setTitle(selectedPaymentMethod, for: .normal)
        }
        // Updating the selected shipping method
        if let shippingMethod = paymentContext.selectedShippingMethod {
            shippingMethodBtn.setTitle(addressLine1, for: .normal)
            //StripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100)
            setupPaymentInfo()
        }else{
            shippingMethodBtn.setTitle("Select", for: .normal)
        }
    }
    
//    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
//        activityIndicator.stopAnimating()
//
//        let alertController = UIAlertController(title: "Error", message: "You must login in before making purchases.", preferredStyle: .alert)
//
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            self.navigationController?.popViewController(animated: true)
//        }
//
//        let login = UIAlertAction(title: "Login", style: .default) { (action) in
//            let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard , bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
//            self.present(controller, animated: true, completion: nil)
//        }
//
//        alertController.addAction(cancel)
//        alertController.addAction(login)
//        present(alertController, animated: true, completion: nil)
////
//    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
           
       }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
         
        let delivery = PKShippingMethod()
        delivery.amount = 1.2
        delivery.label = "Delivery fees (RM 5.00)"
        delivery.detail = "Delivery time between 20-40 minutes"
        delivery.identifier = "FoodLocal Delivery"
        
//        let fedEx = PKShippingMethod()
//        fedEx.amount = 6.99
//        fedEx.label = "FedEx"
//        fedEx.detail = "Arrive tomorrow"
//        fedEx.identifier = "fedex"
        
        if address.postalCode == "56000" {
            addressLine1 = address.line1!
            completion(.valid, nil, [delivery], nil)
            apt = "\(address.line2 ?? "")"
            addressInfoArray = [address.name!, address.phone!, address.line1!, address.line2!]
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
