//
//  API.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 21.10.2022.
//

import Foundation
import UIKit

struct NetworkManager {
    
    
    
    
    let vehicleURL = "https://auto.dev/api/vin/SCBFR7ZA5CC072256?apikey=ZrQEPSkKYWt6aGFuLmthejIwMDNAZ21haWwuY29t"
    
    
    
    func postRequest() {
        let url = URL(string: vehicleURL)!
        
        
        // let partnertoken = "836910c5c8f84cd5a966f927440e4282"
        let authtoken = "ZrQEPSkKYWt6aGFuLmthejIwMDNAZ21haWwuY29t"
        
        
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("Bearer \(authtoken)", forHTTPHeaderField: "authorization")
        //        request.addValue(partnertoken, forHTTPHeaderField: "partner-token")
        request.httpMethod = "GET"
        //        request.httpBody = jsonData
        
        
        
        URLSession.shared.dataTask(with: request) { (data, response , error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
        }.resume()
    }
    
    
    
    
 
}
