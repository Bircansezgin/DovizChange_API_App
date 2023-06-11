//
//  ViewController2.swift
//  DovizConvert
//
//  Created by Bircan Sezgin on 11.06.2023.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var baseCurrentLabel: UILabel!
    @IBOutlet weak var secondCurrentLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    var secondSendMoney = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(secondSendMoney)
        secondCurrentLabel.text = "\(secondSendMoney)"
        
        startApi()
    }
    
    @IBAction func calculateButtonClick(_ sender: Any) {
    
        if let secondMoney = Double(secondCurrentLabel.text ?? ""), let inputMoney = Double(amountTextField.text ?? "") {
              let toplam = secondMoney * inputMoney
              let formattedToplam = String(format: "%.2f", toplam)
              let formattedSecondMoney = String(format: "%.2f", secondMoney)
              let formattedInputMoney = String(format: "%.2f", inputMoney)
              
              let alerts = UIAlertController(title: "Exchange", message: "Result : \(formattedSecondMoney) * \(formattedInputMoney) = \(formattedToplam)", preferredStyle: .alert)
              let ok = UIAlertAction(title: "Ok", style: .cancel)
              alerts.addAction(ok)
              self.present(alerts, animated: true)
          }
    }
    
    
    
    
    func startApi(){
        // 1) Request & Session (Istek Yollamak)

        let url = URL(string: "https://api.fastforex.io/fetch-all?api_key=6431095421-46814537d2-rw2cuf")
        //"http://data.fixer.io/api/latest?access_key=65c9f5e1913452a764636d551a167c89"
        
        // Session
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil{
                
            }else{
                // 2) Response & Data (IStek Almak)
                if data != nil{
                    do{
                        // 3) Parsing & JSON Serialization
                        let jsonResponse = try JSONSerialization.jsonObject(with: data! ,options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        //ASYNC
                        DispatchQueue.main.async {
                            if let rates = jsonResponse["results"] as? [String : Any]{
                                print(rates)
                                if let usd = rates["USD"] as? Double{
                                    self.baseCurrentLabel.text = "USD: \(usd)"
                                }
                            }
                        }
                       
                    }catch{
                        print("Error")
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
}
