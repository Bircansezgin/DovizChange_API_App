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
    
    @IBOutlet weak var tableView: UITableView!
    
    var currencies: [Currency] = []
    
    //http://data.fixer.io/api/latest?access_key=65c9f5e1913452a764636d551a167c89
        
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
    var noOpRub = 0.0
    var noOpDinar = 0.0
    var noOpJPY = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        hidesLabel()
        //dolarsWeek()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.unHidesLabel()
            
            self.startApi()
        }
        
        
        
    }//Finish viewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2" {
            if let navigationController = segue.destination as? UINavigationController,
               let des = navigationController.topViewController as? ViewController2 {
                
                if let senderString = sender as? String {
                    if senderString == "TRY" {
                        des.secondSendMoney = noOpTry
                        des.moneyBirim = "TRY"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "EUR" {
                        des.secondSendMoney = noOpEuro
                        des.moneyBirim = "EUR"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "GBP" {
                        des.secondSendMoney = noOpGPB
                        des.moneyBirim = "GBP"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "RUB"{
                        des.secondSendMoney = noOpRub
                        des.moneyBirim = "RUB"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "KWD"{
                        des.secondSendMoney = noOpDinar
                        des.moneyBirim = "KWD"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "JPY"{
                        des.secondSendMoney = noOpJPY
                        des.moneyBirim = "JPY"
                        des.lastUpdate = dateUpdate
                    }
                }
            }
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
        
        let rubButton = UIAlertAction(title: "RUB", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "go2", sender: "RUB")
        }
        
        let dinarButton = UIAlertAction(title: "KWD", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "go2", sender: "KWD")
        }
        
        let jpyButton = UIAlertAction(title: "JPY", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "go2", sender: "JPY")
        }
        
        alerts.addAction(trybutton)
        alerts.addAction(euroButton)
        alerts.addAction(gbpButton)
        alerts.addAction(rubButton)
        alerts.addAction(dinarButton)
        alerts.addAction(jpyButton)
        
        
        let canceB = UIAlertAction(title: "Cancel", style: .destructive)
        alerts.addAction(canceB)
        self.present(alerts, animated: true)
    }
    
    
    func hidesLabel(){
        loading.isHidden = false
        loading.startAnimating()
       // tableView.isHidden = true
        calculateButton.isHidden = true
    }
    
    func unHidesLabel(){
        loading.isHidden = true
        loading.startAnimating()
 
       // tableView.isHidden = false
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
              
                                if let usd = rates["USD"] as? Double{
                                    self.usdLabel.text = "USD: \(usd)$"
                                }
                                if let trY = rates["TRY"] as? Double{
                                    let formattedTtry = String(format: "%.2f", trY)
                                    let currency = Currency(name: "TRY", flagImage: UIImage(named: "try_flag")!, value: "1 USD = \(formattedTtry)₺")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpTry = trY
                                }
                                if let gbp = rates["GBP"] as? Double{
                                    let formattedTgbp = String(format: "%.2f", gbp)
                                    let currency = Currency(name: "GBP", flagImage: UIImage(named: "gbp_flag.jpg")!, value: "1 USD = \(formattedTgbp)£")
                                    self.tableView.reloadData()
                                    self.currencies.append(currency)
                                    
                                    self.noOpGPB = gbp
                                }
                                
                                if let eurO = rates["EUR"] as? Double{
                                    let formattedTeuro = String(format: "%.2f", eurO)
                                    let currency = Currency(name: "EUR", flagImage: UIImage(named: "eur_flag")!, value: "1 USD = \(formattedTeuro)€")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpEuro = eurO
                                }
                                
                                if let rub = rates["RUB"] as? Double{
                                    let formattedrub = String(format: "%.2f", rub)
                                    let currency = Currency(name: "RUB", flagImage: UIImage(named: "rub.flag")!, value: "1 USD = \(formattedrub)₽")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpRub = rub
                                }
                                
                                if let dinar = rates["KWD"] as? Double{
                                    let formattedDinar = String(format: "%.2f", dinar)
                                    let currency = Currency(name: "KWD", flagImage: UIImage(named: "kuvety_flag")!, value: "1 USD = \(formattedDinar)د.ك")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpDinar = dinar
                                    
                                }
                                
                                if let jpyYen = rates["JPY"] as? Double{
                                    let formattedjpyYen = String(format: "%.2f", jpyYen)
                                    let currency = Currency(name: "JPY", flagImage: UIImage(named: "yen_flag.jpg")!, value: "1 USD = \(formattedjpyYen)¥")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpJPY = jpyYen
                                    
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
    
    
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sendData = currencies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellViewController
        cell.moneyFlagImage.image = sendData.flagImage
        cell.moneyProvision.text = "\(sendData.value)"
        cell.moneyUnitLabel.text = sendData.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 1 == 0 {
            return 130 //her bir hücrenin yüksekliğini 100 puan olarak ayarlar
        } else {
            return 130 //diğer hücrelerin yüksekliğini 130 puan olarak ayarlar
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        if let cell = tableView.cellForRow(at: indexPath) as? cellViewController{
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                cell.alpha = 0.7
                feedbackGenerator.impactOccurred()
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    cell.transform = CGAffineTransform.identity
                    cell.alpha = 1.0
                })
            })
          
            
            let selectedCurrency = currencies[indexPath.row].name
            
            switch selectedCurrency{
            case "TRY":
                performSegue(withIdentifier: "go2", sender: "TRY")
                
            case "EUR":
                performSegue(withIdentifier: "go2", sender: "EUR")
            case "GBP":
                performSegue(withIdentifier: "go2", sender: "GBP")
            case "RUB":
                performSegue(withIdentifier: "go2", sender: "RUB")
            case "KWD":
                performSegue(withIdentifier: "go2", sender: "KWD")
            case "JPY":
                performSegue(withIdentifier: "go2", sender: "JPY")
                
            default:
                break
            }
        }
    }
    
}
