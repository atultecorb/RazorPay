//
//  ViewController.swift
//  RazorPayWork
//
//  Created by Tecorb Technologies on 12/04/23.
//

import UIKit
import Razorpay

class ViewController: UIViewController {
 
    var razorpay: RazorpayCheckout!

    override func viewDidLoad() {
        super.viewDidLoad()
            self.razorpay = RazorpayCheckout.initWithKey(razorpayTestKeyId, andDelegate: self)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       // showPaymentForm()
       }
    
    internal func proceedWithSelectedPaymentMode(orderNumber:String, gatewayOrderId:String){
        let options: [String:Any] = [
            "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "purchase descriptio/n",
            "order_number": orderNumber,
            "order_id": gatewayOrderId,
            "gatewayOrderId": gatewayOrderId,
            "image": "https://url-to-image.jpg",
            "name": "business or product name",
            "prefill": [
                "contact": "9797979797",
                "email": "foo@bar.com"
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        self.razorpay.clearUserData()
        razorpay.open(options)
       // razorpay.open(options, displayController: self)
    }
    
    
    @IBAction func actionOnCreatePayment(_ sender: UIButton) {
        self.createFoodOrder(paymentMode: "card")
    }

}


extension ViewController:RazorpayPaymentCompletionProtocolWithData{
    
    func createFoodOrder(paymentMode:String){
        //Api HIT FOT PAYMENT GATEWAY ID FROM BACKEND SIDE AS WE GET SUCCESS RESPONSE AND RECEIVE PAYMENT GATEWAY ID , ORDER NUMBER THEN REDIRECT TO CREATE PAYMENT
        /*
        if paymentGateWayId != "" && orderNumberId != ""{
         self.proceedWithSelectedPaymentMode(orderNumber: "", gatewayOrderId: "")
        }
        */
        
       
    }
    
  func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
    let message = "\(str)"
    self.razorpay?.close()
    }
    
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
      guard let payment_id = response?["razorpay_payment_id"] as? String else {return}
            //GATEWAY ID FIND FROM BACKENED SIDE
     // guard let gatewayId = self.order?.gatewayOrderId else{return}
      guard let razorpay_orderId = response?["razorpay_order_id"] as? String else {return}
      guard let razorpaySignature = response?["razorpay_signature"] as? String else {return}
      var data = [String:String]()
      data.updateValue(payment_id, forKey: "razorpay_payment_id")
      data.updateValue("gatewayId", forKey: "gatewayOrderId")
      data.updateValue(razorpay_orderId, forKey: "razorpay_order_id")
      data.updateValue(razorpaySignature, forKey: "razorpay_signature")
     // AppSettings.shared.showLoader()
      self.razorpay.close()
        //FOR VERIFY THE ABOVE PAYMENT FROM SERVRER
     /* self.verifyPayment(data:data) { success, message in
        AppSettings.shared.hideLoader()
        if !success{NKToastHelper.sharedInstance.showErrorAlert(self, message: message); return}
        NKToastHelper.sharedInstance.showErrorAlert(self, message: message) {
          self.navigationController?.popToRoot(true)
        }
      }
        */
    }
    
    
    
  }


