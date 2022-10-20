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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.okBtn.layer.cornerRadius = 10
        self.cardView.layer.cornerRadius = 20

   
    }
    
    
    
    @IBAction func okBtnTapped(_ sender: Any) {
        
        let SearchVC = storyboard?.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        SearchVC.modalPresentationStyle = .fullScreen
        SearchVC.modalTransitionStyle = .flipHorizontal
        UserDefaults.standard.hasOnboarded = true
        present(SearchVC, animated: true, completion: nil)
    }
    
    

  

}
