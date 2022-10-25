//
//  VehicleData.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 21.10.2022.
//

import Foundation
import UIKit


struct VehicleData: Codable {
//    let vehicle: Vehicle
//    let message: Message
    var make: Make
//    var engine: Engine
    var transmission: Transmission
    var model: Model
    
}



//struct Vehicle: Codable {
//    let year: String
//    let make: String
//    let model: String
//    let manufacturer: String
//    let engine: String
//    let trim: String
//    let transmission: String
//}


struct Make: Codable {
    var id: Int
    var name: String
    var niceName: String
}


struct Transmission: Codable {
    var id: String
    var name: String
    var equipmentType: String
    var availability: String
    var automaticType: String
    var transmissionType: String
    var numberOfSpeeds: String
}

struct Model: Codable {
    var id: String
    var name: String
    var niceName: String
}

//struct Engine: Codable {
//    var id: String
//    var name: String
//    var equipmentType: String
//    var availability: String
//    var compressionRatio: Double
//    var cylinder: Int
//    var size: Int
//    var displacement: Int
//    var configuration: String
//    var fuelType: String
//    var horsepower: Int
//    var torque: Int
//    var totalValves: Int
//    var type: String
//    var code: String
//    var compressorType: String
//    var RPM: rpm
//    var Valve: valve
//}
//
//struct rpm: Codable {
//   var horsepower: Int
//   var torque: Int
//}
//
//struct valve: Codable {
//   var timing: String
//   var gear: String
//}






//struct Message: Codable {
//    let code: String
//    let message: String
//    let credentials: String
//    let version: String
//    let endpoint: String
//    let counter: String
//}










