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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.seachBTN.layer.cornerRadius = 25

       
    }
    
    
    
    @IBAction func searchBtnClicked(_ sender: Any)  {
        
        if searchTF.text != "" {
            searchCompleted()
        } else {
            showAlert(with: "Please, field requied!", and: "OK")
        }
        
        
    }
    
    
    func searchCompleted() {
        let controller = storyboard?.instantiateViewController(identifier: "InfoViewController") as! InfoViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        UserDefaults.standard.hasOnboarded = true
        present(controller, animated: true, completion: nil)
    }
    
    
    

}


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



