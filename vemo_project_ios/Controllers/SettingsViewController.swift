//
//  SettingsViewController.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 01.11.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class SettingsViewController: UIViewController {

    
    
    @IBOutlet weak var photoImage: UIImageView!
    
    
    @IBOutlet weak var changeImageBtn: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var surnameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var okBtn: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        photoImage.layer.cornerRadius = 40
        photoImage.layer.masksToBounds = true
        photoImage.layer.borderWidth = 3
        
        
        self.cardView.layer.cornerRadius = 30
        self.okBtn.layer.cornerRadius = 15
        
        
        self.fetchUser()
        
    }
    
    
    
    // Transit back to SearchVC
    
    @IBAction func okBtnTapped(_ sender: Any) {
        let SearchVC = storyboard?.instantiateViewController(identifier: "SearchVC") as! SearchViewController
        SearchVC.modalPresentationStyle = .fullScreen
        SearchVC.modalTransitionStyle = .flipHorizontal
        UserDefaults.standard.hasOnboarded = true
        present(SearchVC, animated: true, completion: nil)
    }
    
    
    
    
    
    
    // To get data from database
    
    func fetchUser() {
        
        let userUID = Auth.auth().currentUser?.uid
        db.collection("newusers").document(userUID!).getDocument { [self] snapshot, error in
            if error != nil {
                print("Error")
            }
            else {
                
                let name = snapshot?.get("username") as? String
                self.nameLabel.text = (name)!
                let surname = snapshot?.get("surname") as? String
                self.surnameLabel.text = (surname)!
                let email = snapshot?.get("email") as? String
                self.emailLabel.text = (email)!


                let storage = Storage.storage()
                var reference: StorageReference!
                reference = storage.reference(forURL: "gs://vemoapp-project-ios.appspot.com/useravatars/\(userUID!)")
                reference.downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.photoImage.image = image
                    
                }
                
            }
            
            
        }
    }
    

  

}
