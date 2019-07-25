//
//  ViewController.swift
//  MortgageCalculator
//
//  Created by Jared Porter on 6/12/19.
//  Copyright © 2019 Jared Porter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Variables
    var principle: Double?
    var payments: Int?
    var interest: Double?
    var period: CShort?
    
    // Outlets
    @IBOutlet weak var principleTextField: UITextField!
    @IBOutlet weak var paymentsTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var paymentAmountTextField: UILabel!
    @IBOutlet weak var calculatePaymentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureTapGesture()
        calculatePaymentButton.isEnabled = false
    }
    
    // Actions
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        let principleConv = Double(principleTextField.text!)
        let paymentsConv = Int(paymentsTextField.text!)
        let interestConv = Double(interestTextField.text!)
        
        principle = principleConv
        payments = paymentsConv
        interest = interestConv
        
        print(principle as Any)
        print(payments as Any)
        print(interest as Any)
        
        if (validInput()) {
            calculatePaymentButton.isEnabled = true
        } else {
            calculatePaymentButton.isEnabled = false
        }
        
    }
    
    @IBAction func segControlChanged(_ sender: UISegmentedControl) {
        view.endEditing(true)
        switch sender.selectedSegmentIndex {
        case 1:
            period = 1
        default:
            period = 0
        }
        
        print(period!)
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        view.endEditing(true)
        var payment: Double = 0
        var rate: Double = 0
        switch period {
        case 1:
            rate = (interest! / 100) / 12
        default:
            rate = interest! / 100
        }
        
        if (interest! > 0) {
            let x = pow(1 + rate, Double(payments!))
            payment = principle! * rate * x / (x - 1)
        } else {
            payment = principle! / Double(payments!)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        paymentAmountTextField.text = "Payment Amount: \(formatter.string(from: NSNumber(value: payment))!)"
    }
    
    // Methods
    func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    func configureTextFields() {
        principleTextField.delegate = self
        paymentsTextField.delegate = self
        interestTextField.delegate = self
    }
    
    @objc func handleTap() {
        print("Tap outside of text field detected")
        view.endEditing(true)
    }
    
    func validInput() -> Bool {
        return (principle != nil && principle! > 0 && payments != nil && payments! > 0 && interest != nil && interest! >= 0)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
