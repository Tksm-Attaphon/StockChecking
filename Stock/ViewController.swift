//
//  ViewController.swift
//  Stock
//
//  Created by attaphon eamsahard on 8/17/2560 BE.
//  Copyright © 2560 attaphon eamsahard. All rights reserved.
//

import UIKit
import Kanna
import RealmSwift


class ViewController: UIViewController {

   
    let realm = try! Realm()
    let setArray = Array<String>()
    var x: Int {
        get { return Int(arc4random_uniform(6) + 1) }
    }
    
    @IBAction func gotoSeeDetail(_ sender: Any) {
        print("clickable")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let stats = self.realm.objects(Status.self)
        let stocks = self.realm.objects(STOCK.self)
        
        for i in 0..<stocks.count {
            let s = stocks[i]
            
            print(s.name)
            for j in 0..<stats.count {
                let st = stats[j]
                if st.owner == s {
                    print(st.date ?? " NO DATA ")
                }
            }
            // ...
        }

    }
    @IBAction func startSync(_ sender: Any) {
        startSync()
    }
    func startSync() {
        try! realm.write {
            realm.deleteAll()
        }
        
        DispatchQueue.main.async {
            for item in self.getListStock() {
                 self.parse(stockName: item)
            }
           
            
        }
    }
    func getListStock() ->Array<String> {
        var array = Array<String>()
        var arrayResult = Array<String>()
        array.append(self.getHTML(stockName: "",url: "https://www.set.or.th/set/commonslookup.do?language=th&country=TH&prefix=NUMBER"))
        
        for char in "abcdefghijklmnopqrstuvwxyz".characters {
            array.append(self.getHTML(stockName: "",url: "https://www.set.or.th/set/commonslookup.do?language=th&country=TH&prefix=\(char)"))
        }
        
        for  html in array {
            if let doc = HTML(html: html, encoding: .utf8) {
                
                
                // Search for nodes by CSS
                for tr in doc.css("tr,top") {
                    
                    for td in tr.css("td") {
                        
                        //print(td.text ?? "")
                        if let textStock = td.text {
                           arrayResult.append(textStock)
                        }
                        
                        break
                    }
                }
            }
        }
        
        
        
        return arrayResult
    }
    func getHTML(stockName:String,url:String? = nil) -> String{
        
        
        var myURLString = "https://www.set.or.th/set/historicaltrading.do?symbol=\(stockName)&language=th&country=TH"
        if let urlTemp = url {
            myURLString = urlTemp
        }
        
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return ""
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            //print("HTML : \(myHTMLString)")
             return myHTMLString
        } catch let error {
             print("Error: \(error)")
            return ""
           
        }
        
        
       
    }
    func parse(stockName:String){
        
        let stock = STOCK()
        stock.name = stockName
        try! realm.write {
            realm.add(stock)
        }
        
        let html = self.getHTML(stockName: stockName)
        
        
        if let doc = HTML(html: html, encoding: .utf8) {

            
            // Search for nodes by CSS
            for tr in doc.css("tr,right") {
                print ("start row")
                let s = Status()
                
                var i = 0
                for td in tr.css("td") {
                    //
                    
                    switch i {
                    case 0:
                        // 
                        print(td.text ?? "")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/mm/yyyy" //Your date format
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                        let date = dateFormatter.date(from: td.text!)
                        
                        s.date = date
                        
                        break
                    case 1:
                        //
                        if let lat = td.text {
                            s.open = Float((lat as NSString).floatValue)
                        }
                        
                        
                        break
                    case 2:
                        //
                        if let lat = td.text {
                            s.hight = Float((lat as NSString).floatValue)
                        }
                        break
                    case 3:
                        //
                        if let lat = td.text {
                            s.low = Float((lat as NSString).floatValue)
                        }
                        
                        break
                    case 4:
                        //
                        if let lat = td.text {
                            s.close = Float((lat as NSString).floatValue)
                        }
                        
                        break
                    case 5:
                        //
                        if let lat = td.text {
                            s.change = Float((lat as NSString).floatValue)
                        }
                        break
                    case 6:
                        //
                        if let lat = td.text {
                            s.percentChange = Float((lat as NSString).floatValue)
                        }
                        break
                    case 7:
                        //
                        if let lat = td.text {
                            s.totalValume = Int((lat as NSString).intValue)
                        }
                        break
                    case 8:
                        //
                        if let lat = td.text {
                            s.totalValue = Float((lat as NSString).floatValue)
                        }
                        break
                    default:
                        //..
                        break
                    }
                    i+=1

                }
                s.owner = stock
                //
                try! realm.write {
                    realm.add(s)
                    stock.status.append(s)
                }
                
                //print ("end row")
            }

            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

