
<p align="left">
  <img src="https://github.com/manste1n/vemo_project_ios/blob/main/Screens/icon.png" width="110" title="main">
</p>


# Vemo App

VEMO is a project to be developed in Swift for iOS devices. The project aims to automate the search for car information for people who are interested, the point is that the application will be connected to a common database which contains information about many cars. 

The user by entering the car number, get full information about the model of the car, year of manufacture, and general information, etc.


&nbsp;


## Presentation Screen

<p align="center">
  <img src="https://github.com/manste1n/vemo_project_ios/blob/main/Screens/1.png" width="200" title="1">
  &nbsp;
  &nbsp;
  &nbsp;
  <img src="https://github.com/manste1n/vemo_project_ios/blob/main/Screens/2.png" width="200" title="2">
  &nbsp;
  &nbsp;
  &nbsp;
  <img src="https://github.com/manste1n/vemo_project_ios/blob/main/Screens/3.png" width="200" title="2">
  
</p>

## Login, Register Screens

<p align="center">
  <img src="https://github.com/manste1n/vemo_project_ios/blob/main/Screens/4.png" width="200" title="1">
   &nbsp;
  &nbsp;
  &nbsp;
   <img src="https://github.com/manste1n/vemo_project_ios/blob/main/Screens/5.png" width="200" title="1">
  
</p>


## Search, Settings, Info Screens

<p align="center">
  <img src="https://github.com/manste1n/vemo_project_ios/blob/main/Screens/6.png" width="200" title="1">
   &nbsp;
  &nbsp;
  &nbsp;
   <img src="https://github.com/manste1n/vemo_project_ios/blob/main/Screens/7.png" width="200" title="1">
   &nbsp;
  &nbsp;
  &nbsp;
   <img src="https://github.com/manste1n/vemo_project_ios/blob/main/Screens/8.png" width="200" title="1">
  
</p>




## Features

- [x] The app is available on the new version of Xcode and iOS 16.0 
- [x] Ability to register and login using Firebase
- [x] Ability to search for vehicle information using the VIN and auto.dev API
- [x] Comfortable UI/UX Design
- [x] Open to all devices 


&nbsp;
   
## Code Review

- API Request

```sh
   
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
    
``` 


- Vehicle Info 
 ```sh
 
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

...


&nbsp;

## Installation

#### Requirements
- Xcode 13+ with an iOS 13.0+ simulator
- Firebase CocoaPods
- auto.dev API

#### Installation steps
1. Clone the repo: `git clone https://github.com/manste1n/vemo_project_ios`
2. Register your Firebase Project by instructions in official page




&nbsp;



Thx for attention :3

You can support me by following :>

