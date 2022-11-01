//
//  RegisterViewController.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 31.10.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var photoVIew: UIImageView!
    
    @IBOutlet weak var changeImageBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    // Image Picker
    var imagePicker:UIImagePickerController!
    
    // Image url
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.layer.cornerRadius = 20
        
        activityView.isHidden = true
        signUpBtn.layer.cornerRadius = 10
        
        
        setRegButton(enabled: false)
        
        nameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        surnameTF.delegate = self
        
        nameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        surnameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        photoVIew.layer.cornerRadius = 35
        photoVIew.layer.masksToBounds = true
        photoVIew.layer.borderWidth = 3
        photoVIew.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
        
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    
    
    
    // Keyboard settings to hide and show
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(sender:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // Special code to automatically resizing view with keyboard
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        
        
        
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        // if textField bottom is below keyboard bottom - bump the frame up
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    
    // Function to access the button after filling in the textfields
    
    @objc func textFieldChanged(_ target:UITextField) {
        let name = nameTF.text
        let email = emailTF.text
        let password = passwordTF.text
        let surename = surnameTF.text
        let formFilled = name != nil && name != "" && email != nil && email != "" && password != nil && password != "" && surename != nil && surename != ""
        setRegButton(enabled: formFilled)
    }
    
    
    func setRegButton(enabled:Bool) {
        if enabled {
            signUpBtn.alpha = 1
            signUpBtn.isEnabled = true
        } else {
            signUpBtn.alpha = 0.5
            signUpBtn.isEnabled = false
        }
    }
    
    
    
    
    // Change image by clicking button
    
    @IBAction func changeImageBtnPressed(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    // Uploading image in firebase storage by user id and image url
    
    func upload(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child("useravatars").child(currentUserId)
        
        guard let imageData = photoVIew.image?.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
    
    
    
    
    // Register process
    
    
    func register(email: String?, password: String?, completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isFilledReg(username: nameTF.text,
                                     surename: surnameTF.text,
                                     email: emailTF.text,
                                     password: passwordTF.text)
                                     else {
                                    completion(.failure(AuthError.notFilled))
                                    return
        }
        guard let email = email, let password = password else {
            completion(.failure(AuthError.unknownError))
            return
        }
        
        guard Validators.isSimpleEmail(email) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
    
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            self.upload(currentUserId: result.user.uid, photo: self.photoVIew.image!) { (myresult) in
                switch myresult {
                case .success(let url):
                    self.urlString = url.absoluteString
                    let db = Firestore.firestore()
                    db.collection("newusers").document(result.user.uid).setData([
                        "username": self.nameTF.text!,
                        "surname": self.surnameTF.text!,
                        "email": self.emailTF.text!,
                        "password": self.passwordTF.text!,
                        "avatarURL": url.absoluteString,
                        "uid": result.user.uid
                    ]) { (error) in
                        if let error = error {
                            completion(.failure(error))
                        }
                        completion(.success)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
            
        }
    }
    
    
    // Sign up process
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        setRegButton(enabled: false)
        signUpBtn.setTitle("", for: .normal)
        activityView.isHidden = false
        activityView.startAnimating()
        
        register(email: emailTF.text, password: passwordTF.text) { (result) in
            switch result {
            case .success:
                self.showAlert(with: "Success", and: "You successfully registered!", completion: {
                    self.setRegButton(enabled: true)
                    self.signUpBtn.setTitle("Sign Up", for: .normal)
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                    self.transitionToSearch()
                })
            case .failure(let error):
                self.setRegButton(enabled: true)
                self.signUpBtn.setTitle("Sign Up", for: .normal)
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
        
    }
    
    
    
    // Go to SearchVC
    
    func transitionToSearch() {
        
        let SearchVC = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? SearchViewController
        view.window?.rootViewController = SearchVC
        view.window?.makeKeyAndVisible()
    }
    
}





extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        photoVIew.image = image
    }
}

extension RegisterViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

    

   
        
        
        
        
    
    

    


