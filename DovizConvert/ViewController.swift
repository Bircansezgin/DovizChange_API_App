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
    
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getRatesButton(_ sender: Any) {
        
        // 1) Request & Session (Istek Yollamak)
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=65c9f5e1913452a764636d551a167c89")
        
        // Session
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil{
                let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }else{
                
                // 2) Response & Data (IStek Almak)
                if data != nil{
                    do{
                        // 3) Parsing & JSON Serialization
                        let jsonResponse = try JSONSerialization.jsonObject(with: data! ,options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        //ASYNC
                        DispatchQueue.main.async {
                            if let rates = jsonResponse["rates"] as? [String : Any]{
                                //print(rates)
                                if let cad = rates["CAD"] as? Double{
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                if let gbp = rates["GBP"] as? Double{
                                    self.gbpLabel.text = "GPB: \(gbp)"
                                }
                                if let jpy = rates["JPY"] as? Double{
                                    self.jpyLabel.text = "JPY: \(jpy)"
                                }
                                if let usd = rates["USD"] as? Double{
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                if let trY = rates["TRY"] as? Double{
                                    self.tryLabel.text = "TRY: \(trY)"
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


