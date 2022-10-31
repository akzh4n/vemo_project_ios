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
    @IBOutlet weak var needspeedLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var availabLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var okBtn: UIButton!
    

    
    var model: Vehicle?
    
    var networkManager = NetworkManager()
    var searchViewControllerInstance: SearchViewController?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    
        
        self.okBtn.layer.cornerRadius = 10
        self.cardView.layer.cornerRadius = 20
        
        
        self.getData()
        
        self.imageSettings(carNameText: self.carName.text)
        
        
        
          
    }
    
    
    
    
    // Func to get data with image, have used because of there are no images from VIN Code
    // Added by some reasons, but you can change and add your personal image or use other API
    
    func imageSettings(carNameText: String?) {
        if(carNameText == "Bentley") {//SCBFR7ZA5CC072256
            self.carImageView.image = UIImage(named: "bentleycarnew")
        }
        if(carNameText == "Lamborghini") { //ZPBUA1ZL9KLA00848
            self.carImageView.image = UIImage(named: "newlambocar")
        }
        if(carNameText == "Chevrolet") { //2G1WD58C869421675
            self.carImageView.image = UIImage(named: "bugatticar")
        }
    }
    
    
    
    
    // This function fully to get data from API and show
    
    func getData() {
        
        modelLabel.text = model?.model?.name
        carName.text = model?.make?.name
        
        
        let yearText = model?.years?[0].year
        
        let yearTextString = "\(yearText ?? 0)"
        yearLabel.text = yearTextString
        
        let priceText = model?.price?.baseMsrp
        let priceTextString = "\(priceText ?? 0)"
        priceLabel.text = priceTextString
        
        
        availabLabel.text = model?.transmission?.availability
        transmissionLabel.text = model?.transmission?.transmissionType
        needspeedLabel.text = model?.transmission?.numberOfSpeeds
    }
    
    
    
    // To go back
    @IBAction func okBtnTapped(_ sender: Any) {
        
        let SearchVC = storyboard?.instantiateViewController(identifier: "SearchVC") as! SearchViewController
        SearchVC.modalPresentationStyle = .fullScreen
        SearchVC.modalTransitionStyle = .flipHorizontal
        UserDefaults.standard.hasOnboarded = true
        present(SearchVC, animated: true, completion: nil)
    }
    
    

}


    
    
    
    
    
    
    

    


   
    
    

