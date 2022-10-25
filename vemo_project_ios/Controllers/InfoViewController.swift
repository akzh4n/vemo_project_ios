//
//  InfoViewController.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 20.10.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var transmissionLabel: UILabel!
    @IBOutlet weak var manufactLabel: UILabel!
    
    @IBOutlet weak var engineLabel: UILabel!
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var trimlabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    
    
    
    @IBOutlet weak var okBtn: UIButton!

    var networkManager = NetworkManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.okBtn.layer.cornerRadius = 10
        self.cardView.layer.cornerRadius = 20
        
      
        networkManager.postRequest()
        self.performRequest()
       
    
    }
    
    
    
    @IBAction func okBtnTapped(_ sender: Any) {
        
        let SearchVC = storyboard?.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        SearchVC.modalPresentationStyle = .fullScreen
        SearchVC.modalTransitionStyle = .flipHorizontal
        UserDefaults.standard.hasOnboarded = true
        present(SearchVC, animated: true, completion: nil)
    }
    
    
    
    func performRequest() {
        
        
    let vehicleURL = "https://auto.dev/api/vin/SCBFR7ZA5CC072256?apikey=ZrQEPSkKYWt6aGFuLmthejIwMDNAZ21haWwuY29t"
    let url = URL(string: vehicleURL)
        
    guard url != nil else {
        return
    }

        let session = URLSession.shared

        let dataTask = session.dataTask(with: url!) { (data, response, error) in

        if error == nil && data != nil {

         let decoder = JSONDecoder()

         do {

           let decodedData = try decoder.decode(VehicleData.self, from: data!)

           print(decodedData)

             DispatchQueue.main.async {
                 self.carName.text = decodedData.make.name
                 self.yearLabel.text = decodedData.transmission.numberOfSpeeds
                 self.modelLabel.text = decodedData.model.name
                 self.trimlabel.text = decodedData.transmission.availability
                 self.engineLabel.text = decodedData.transmission.equipmentType
                 self.transmissionLabel.text = decodedData.transmission.transmissionType
                 self.manufactLabel.text = decodedData.transmission.automaticType
                 
//                 self.engineLabel.text = decodedData.transmission.equipmentType
//                 self.trimlabel.text = decodedData.transmission.availability
//                 self.transmissionLabel.text = String(decodedData.transmission.automaticType)
//                 self.modelLabel.text = decodedData.transmission.transmissionType
//                 self.carName.text = String(decodedData.transmission.numberOfSpeeds)
                 
                 
             }
           }
           catch {
               print("Error Parsing JSON")
            }

        }

    }

    dataTask.resume()
 }
    
}
    
    

  



