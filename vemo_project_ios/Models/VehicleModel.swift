//
//  VehicleModel.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 26.10.2022.
//

import Foundation
import UIKit

struct Vehicle: Decodable {
    let make: VehicleMake?
    let model: VehicleModel?
    let transmission: VehicleTransmission?
    let price: VehiclePrice?
    let years: [VehicleYears]?

}

struct VehicleMake: Decodable {
    let id: Int?
    let name: String?
    let niceName: String?
}

struct VehicleModel: Decodable {
    let id: String?
    let name: String?
    let niceName: String?
}

struct VehicleTransmission: Decodable {
    let numberOfSpeeds: String?
    let availability: String?
    let transmissionType: String?
    let automaticType: String?
}


struct VehiclePrice: Decodable {
    let baseMsrp: Int?
    let deliveryCharges: Int?
    let estimateTmv: Bool?
}


struct VehicleYears: Decodable {
    let id: Int?
    let year: Int?
}

