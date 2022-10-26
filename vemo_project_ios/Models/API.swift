//
//  API.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 21.10.2022.
//

import Foundation
import UIKit


public class NetworkManager {
    
    
    let baseURL = "https://auto.dev/api/vin"
    
    
    func getRequest(for vinCode: String, completion: @escaping ((Vehicle) -> ())) {
        if let url = URL (string: (baseURL + "/\(vinCode)" + ("?apikey=ZrQEPSkKYWt6aGFuLmthejIwMDNAZ21haWwuY29t"))) {
            
            let authtoken = "ZrQEPSkKYWt6aGFuLmthejIwMDNAZ21haWwuY29t"
            
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
    
    
    
//    static func getRequest(for vinCode: String, completion: @escaping (Result<Vehicle, Error>) -> Void) {
//        let baseURL = "https://auto.dev/api/vin"
//        if let url = URL (string: (baseURL + "/\(vinCode)" + ("?apikey=ZrQEPSkKYWt6aGFuLmthejIwMDNAZ21haWwuY29t"))) {
//            URLSession.shared.dataTask(with: url) { data, urlResponse, error in
//                if let _ = error {
//                    completion(.failure(error!))
//                }
//
//                guard let data = data else {
//                    completion(.failure(error!))
//                    return
//                }
//
//                guard let vehicleData = try? JSONDecoder().decode(Vehicle.self, from: data) else {
//                    completion(.failure(error!))
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    completion(.success(vehicleData))
//                }
//
//            }
//            .resume()
//        }
    
}


    













