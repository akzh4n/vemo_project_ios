//
//  API.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 21.10.2022.
//

import Foundation
import UIKit


public class NetworkManager {
    
    
    // Function for automatically writing your own VIN Code and requesting + receiving data
    // YOU CAN GET API KEY FROM auto.dev
    
    let baseURL = "https://auto.dev/api/vin"
    
    func getRequest(for vinCode: String, completion: @escaping ((Vehicle) -> ())) {
        if let url = URL (string: (baseURL + "/\(vinCode)" + ("?apikey=YOURAPIKEY"))) {
            
            let authtoken = "YOUR AUTH TOKEN"
            
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.addValue("Bearer \(authtoken)", forHTTPHeaderField: "authorization")
            
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data, response , error) in
                guard let data = data else { return }
                
                if let model = try? JSONDecoder().decode(Vehicle.self, from: data) {
                    print(model)
                    completion(model)
                } else  {
                    print("Error")
                }
                
            }
            .resume()
        }
    }
    

    
}


    













