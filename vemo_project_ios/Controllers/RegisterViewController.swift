//
//  RegisterViewController.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 31.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    
    @IBOutlet weak var emailTF: UITextField!
    
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
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
    
    
    func register(email: String?, password: String?, completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isFilledReg(username: nameTF.text,
                                     email: emailTF.text,
                                     password: passwordTF.text,
                                     surename: surnameTF.text) else {
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
            guard result != nil else {
                completion(.failure(error!))
                
                let userUID = Auth.auth().currentUser?.uid
                let db = Firestore.firestore()
                db.collection("newusers").document(userUID!).setData([
                    "name": self.nameTF.text!,
                    "surename": self.surnameTF.text!,
                    "password": self.passwordTF.text!,
                    "email": self.emailTF.text!,
                ]) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    }
                    completion(.success)
                }
                return
            }
            return print("Error")
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
    
    
    
    // Go to onboarding
    
    func transitionToSearch() {
        
        let SearchVC = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? OnboardingViewController
        
        view.window?.rootViewController = SearchVC
        view.window?.makeKeyAndVisible()
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

    

   
        
        
        
        
    
    

    


