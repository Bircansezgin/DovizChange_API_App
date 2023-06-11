//
//  ViewController.swift
//  DovizConvert
//
//  Created by Bircan Sezgin on 25.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    //http://data.fixer.io/api/latest?access_key=65c9f5e1913452a764636d551a167c89
    
    // 3 step.
    
  
    @IBOutlet weak var euroLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
        
    var noOpTry = 0.0
    var noOpGPB = 0.0
    var noOpEuro = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startApi()
    }//Finish viewController

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2"{
            let des = segue.destination as! ViewController2
            if let senderDeger = sender as? Double{
                des.secondSendMoney = senderDeger
            }
        }
    }
    

    @IBAction func getRatesButton(_ sender: Any) {
        
        let alerts = UIAlertController(title: "USD ", message: "to Exchange", preferredStyle: .alert)
        let trybutton = UIAlertAction(title: "TRY", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "go2", sender: self.noOpTry)
        }
        
        let euroButton = UIAlertAction(title: "EURO", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "go2", sender: self.noOpEuro)
        }
        
        let gbpButton = UIAlertAction(title: "GBP", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "go2", sender: self.noOpGPB)
        }
        
        alerts.addAction(trybutton)
        alerts.addAction(euroButton)
        alerts.addAction(gbpButton)
        self.present(alerts, animated: true)
        
   

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
    
}


