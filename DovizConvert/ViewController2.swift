//
//  ViewController2.swift
//  DovizConvert
//
//  Created by Bircan Sezgin on 11.06.2023.
//

import UIKit

class ViewController2: UIViewController {
    
    
    @IBOutlet weak var dolarsWeekRates: UILabel!
    
    @IBOutlet weak var baseCurrentLabel: UILabel!
    @IBOutlet weak var secondCurrentLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    var lastUpdate = ""
    var moneyBirim = ""
    var showMoney = ""
    var secondSendMoney = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        secondCurrentLabel.text = "\(secondSendMoney) \(moneyBirim)"
        dolarsWeek(moneyUnit: moneyBirim)
        lastUpdateLabel.text = "Updated : \(lastUpdate)"
        baseCurrentLabel.text = "USD : 1.0$"
        
        self.navigationItem.title = "USD  TO  \(moneyBirim)"
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(turnOffAll))
        view.addGestureRecognizer(gesture)
                                             
    }// Finish ViewDidLoad!
    
        @objc func turnOffAll(){
            view.endEditing(true)
        }
                                             
                                             
                                             
                                             
    @IBAction func calculateButtonClick(_ sender: Any) {
        
        if let inputMoney = Double(amountTextField.text ?? "") {
            let toplam = secondSendMoney * inputMoney
            let formattedToplam = String(format: "%.2f", toplam)
            let formattedInputMoney = String(format: "%.2f", inputMoney)
            
            
            
            let alerts = UIAlertController(title: "Exchange Results", message: "\n\(formattedInputMoney) $ = \(formattedToplam) \(moneyBirim)\n\nUpdated Date: \(lastUpdate)", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel)
            alerts.addAction(ok)
            self.present(alerts, animated: true)
        } else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen geçerli bir sayı girin.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
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
                let alerts = UIAlertController(title: "ERROR", message: error?.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel)
                alerts.addAction(ok)
                self.present(alerts, animated: true)
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
                                    self.baseCurrentLabel.text = "USD: \(usd)$"
                                }
                            }
                            
                            if let dateRates = jsonResponse["updated"] as? String{
                                self.lastUpdateLabel.text = dateRates
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
    
    
    func dolarsWeek(moneyUnit: String){
        let apiKey = "6431095421-46814537d2-rw2cuf"
        let urlStr = "https://api.fastforex.io/time-series?from=USD&to=\(moneyUnit)&interval=P1D&api_key=\(apiKey)"
        
        guard let url = URL(string: urlStr) else {
            print("Geçersiz URL.")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("İstek hatası: \(error.localizedDescription)")
                return
            }
            else{
                if data != nil{
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        DispatchQueue.main.async {
                            if let results = jsonResponse["results"] as? [String: Any],
                               let tryRates = results["\(moneyUnit)"] as? [String: Double] {
                                var ratesText = ""
                                for (date, rate) in tryRates {
                                    print("\(date), \(rate)")
                                    ratesText += "\(date), \(rate)\n"
                                }
                                self.dolarsWeekRates.text = ratesText
                            }
                        }
                    } catch {
                        print("JSON dönüştürme hatası: \(error.localizedDescription)")
                    }

                }
            }
            
        }
        task.resume()
    }
    
}
