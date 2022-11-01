//
//  LoginViewController.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 31.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTF: UITextField!
   
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
   
    @IBOutlet weak var regBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cardView.layer.cornerRadius = 20
        
        loginBtn.layer.cornerRadius = 10
        regBtn.isUserInteractionEnabled = true
       
        setLogButton(enabled: false)
        activityView.isHidden = true
        
        
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        emailTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        
        // To remove keyboard by tapping view
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
      

       

    }
    
    // Go to the registrations page
    

    @IBAction func regBtnTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let RegisterVC = (storyboard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterViewController)!
        self.navigationController?.pushViewController(RegisterVC, animated: true)
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
        let email = emailTF.text
        let password = passwordTF.text

        let formFilled = email != nil && email != "" && password != nil && password != ""
        setLogButton(enabled: formFilled)
    }
    
    func setLogButton(enabled:Bool) {
            if enabled {
                loginBtn.alpha = 1
                loginBtn.isEnabled = true
            } else {
                loginBtn.alpha = 0.5
                loginBtn.isEnabled = false
            }
        }
    
    
    
    
    // Login process
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        view.endEditing(true)
        // TODO: Validate Text Fields
        
        // Create cleaned versions of the text field
        let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
    
        
        setLogButton(enabled: false)
        loginBtn.setTitle("", for: .normal)
        activityView.isHidden = false
        activityView.startAnimating()
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        
            if error != nil {
                // Couldn't sign in
                self.showAlert(with: "Error", and: "The user doesn`t exist")
                self.setLogButton(enabled: true)
                self.loginBtn.setTitle("OK", for: .normal)
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
               
            }
            else {
                
                let SearchVC = self.storyboard?.instantiateViewController(identifier: "SearchVC") as? SearchViewController
                
                self.view.window?.rootViewController = SearchVC
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}


// Extenstion for special alerts

extension LoginViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
    

   

