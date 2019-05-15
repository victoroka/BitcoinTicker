//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Victor Oka on 15/05/2019.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL: String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray: [String] = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray: [String] = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL: String = ""
    var currencySelected: String = ""

    // Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    // PickerView methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Setting the currency symbol as soon as the currency is selected
        currencySelected = currencySymbolArray[row]
        finalURL = baseURL + currencyArray[row]
        getBitcoinValueData(url: finalURL)
    }
    
    // MARK: - Networking
    /***************************************************************/
    
    func getBitcoinValueData(url: String) {
        // Requesting the data from the API
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                // If there is a result from the API
                print("Sucess! Got the bitcoin value!")
                let bitcoinDataJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinValueData(json: bitcoinDataJSON)
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
    }
    
    // MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinValueData(json: JSON) {
        if let bitcoinPrice = json["ask"].double {
            // Update UI with the new bitcoin price given (no need to create a separate method)
            bitcoinPriceLabel.text = "\(currencySelected)\(bitcoinPrice)"
        } else {
            // If theres an error with the result
            bitcoinPriceLabel.text = "Bitcoin Price Unavailable"
        }
    }
    
}
