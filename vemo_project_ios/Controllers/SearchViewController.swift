//
//  SearchViewController.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 19.10.2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var seachBTN: UIButton!
    @IBOutlet weak var searchTF: UITextField!

    @IBOutlet weak var settingsBtn: UIButton!
    
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.seachBTN.layer.cornerRadius = 35
   
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
 
    }

    
    // Go to Settings View
    
    @IBAction func settingsBtnTapped(_ sender: Any) {
        let SettingsVC = storyboard?.instantiateViewController(identifier: "SettingsVC") as! SettingsViewController
        SettingsVC.modalPresentationStyle = .fullScreen
        SettingsVC.modalTransitionStyle = .flipHorizontal
        UserDefaults.standard.hasOnboarded = true
        present(SettingsVC, animated: true, completion: nil)
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


    // Conditions to check and get data + transition
    
    @IBAction func searchBtnClicked(_ sender: Any)  {
        
        if searchTF.text != "" {
            networkManager.getRequest(for: searchTF.text!, completion: { [unowned self] model in
              DispatchQueue.main.async {
                    self.searchCompleted(model: model)
                }
                
            })
    
            
        } else {
            showAlert(with: "Error", and: "Please fill in an empty cell")
        }
    }
    
    
    
    
    
    // Transition to InfoViewController
    func searchCompleted(model: Vehicle) {
        
        let InfoVC = storyboard?.instantiateViewController(identifier: "InfoVC") as! InfoViewController
        InfoVC.model = model
        InfoVC.modalPresentationStyle = .fullScreen
        InfoVC.modalTransitionStyle = .flipHorizontal
        UserDefaults.standard.hasOnboarded = true
        present(InfoVC, animated: true, completion: nil)
    }
}


// Extension for use Alert Window
extension SearchViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
