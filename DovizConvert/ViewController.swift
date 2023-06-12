//
//  ViewController.swift
//  DovizConvert
//
//  Created by Bircan Sezgin on 25.05.2023.
//

import UIKit

/*
 DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
 
 }
 */

class ViewController: UIViewController {
    
    
    
    
    //http://data.fixer.io/api/latest?access_key=65c9f5e1913452a764636d551a167c89
    
    // 3 step.
    
    
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var euroLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    var dateUpdate = ""
    var noOpTry = 0.0
    var noOpGPB = 0.0
    var noOpEuro = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesLabel()
       // dolarsWeek()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.unHidesLabel()
            
            self.startApi()
        }
        
    }//Finish viewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2"{
            let des = segue.destination as! ViewController2
            
            if let senderString = sender as? String{
                
                if senderString == "TRY"{
                    des.secondSendMoney = noOpTry
                    des.moneyBirim = "TRY"
                    des.lastUpdate = dateUpdate
                }
                
                if senderString == "EUR"{
                    des.secondSendMoney = noOpEuro
                    des.moneyBirim = "EUR"
                    des.lastUpdate = dateUpdate
                    
                }
                
                if senderString == "GBP"{
                    des.secondSendMoney = noOpGPB
                    des.moneyBirim = "GBP"
                    des.lastUpdate = dateUpdate
                }
                
                
            }
            
            /* if let senderDeger = sender as? Double{
             des.secondSendMoney = senderDeger
             }*/
        }
    }
    
    
    @IBAction func getRatesButton(_ sender: Any) {
        
        let alerts = UIAlertController(title: "USD ", message: "to Exchange", preferredStyle: .alert)
        let trybutton = UIAlertAction(title: "TRY", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "go2", sender: "TRY")
        }
        
        let euroButton = UIAlertAction(title: "EURO", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "go2", sender: "EUR")
        }
        
        let gbpButton = UIAlertAction(title: "GBP", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "go2", sender: "GBP")
        }
        
        alerts.addAction(trybutton)
        alerts.addAction(euroButton)
        alerts.addAction(gbpButton)
        self.present(alerts, animated: true)
        
        
        
    }
    
    
    func hidesLabel(){
        loading.isHidden = false
        loading.startAnimating()
        
        
        euroLabel.isHidden = true
        gbpLabel.isHidden = true
        usdLabel.isHidden = true
        tryLabel.isHidden = true
        lastUpdateLabel.isHidden = true
        calculateButton.isHidden = true
    }
    
    func unHidesLabel(){
        loading.isHidden = true
        loading.startAnimating()
        
        
        euroLabel.isHidden = false
        gbpLabel.isHidden = false
        usdLabel.isHidden = false
        tryLabel.isHidden = false
        lastUpdateLabel.isHidden = false
        calculateButton.isHidden = false
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
                                
                                if let gbp = rates["GBP"] as? Double{
                                    let formattedTgbp = String(format: "%.2f", gbp)
                                    self.gbpLabel.text = "GPB: \(formattedTgbp)£"
                                    self.noOpGPB = gbp
                                }
                                if let usd = rates["USD"] as? Double{
                                    self.usdLabel.text = "USD: \(usd)$"
                                }
                                if let trY = rates["TRY"] as? Double{
                                    let formattedTtry = String(format: "%.2f", trY)
                                    self.tryLabel.text = "TRY: \(formattedTtry)₺"
                                    self.noOpTry = trY
                                }
                                if let eurO = rates["EUR"] as? Double{
                                    let formattedTeuro = String(format: "%.2f", eurO)
                                    self.euroLabel.text = "EURO: \(formattedTeuro)€"
                                    self.noOpEuro = eurO
                                }
                                
                                
                                if let dateRates = jsonResponse["updated"] as? String{
                                    self.lastUpdateLabel.text = dateRates
                                    self.dateUpdate = dateRates
                                }
                            }// Finish Rates!
                        }
                        
                    }catch{
                        print("Error")
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    
    func dolarsWeek(){
        let apiKey = "6431095421-46814537d2-rw2cuf"
        let urlStr = "https://api.fastforex.io/time-series?from=USD&to=TRY&interval=P1D&api_key=\(apiKey)"
        
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
                               let tryRates = results["TRY"] as? [String: Double] {
                                for (date, rate) in tryRates {
                                    print("Date: \(date), Rate: \(rate)")
                                }
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


