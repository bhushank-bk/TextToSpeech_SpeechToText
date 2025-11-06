//
//  SignupViewController.swift
//  mood_capture
//
//  Created by MacBook on 21/10/24.
//

import UIKit
import Combine

class SignupViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtSignIn: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var lableSignIn: UILabel!
    private var cancellables = Set<AnyCancellable>()

    let viewModel = SignUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
        txtSignIn.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(signInTapped))
        txtSignIn.addGestureRecognizer(gesture)
        [txtName, txtEmail, txtPassword, txtConfirmPassword].forEach {
            $0?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
        self.setupBindings()
    }
    
    @objc func signInTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignupClicked(_ sender: UIButton) {
        txtName.animateRedBorderIfEmpty()
        txtEmail.animateRedBorderIfEmpty()
        txtPassword.animateRedBorderIfEmpty()
        txtConfirmPassword.animateRedBorderIfEmpty()
        if(areAllFieldsFilled()){
            if(!Utils.isValidEmail(data: txtEmail.text ?? "")){
                showToast(message: "Please Enter Valid Email Id")
                return
            }
            self.showLoader()
            viewModel.signUp(email: txtEmail.text!, password: txtPassword.text!)
//            self.navigationController?.popViewController(animated: true)
//            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func areAllFieldsFilled() -> Bool {
        return !(txtName.text?.isEmpty ?? true) &&
        !(txtEmail.text?.isEmpty ?? true) &&
        !(txtPassword.text?.isEmpty ?? true) &&
        !(txtConfirmPassword.text?.isEmpty ?? true)
    }
    
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        textField.animateRedBorderIfEmpty()
    }
    
    private func setupBindings() {
        viewModel.$isUserSignUp
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSigned in
                
                if isSigned == true
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.hideLoader()
                    }
                    self?.showToast(message: "Successfully Sign Up")
                    self?.navigationController?.popViewController(animated: true)
                    
                }
                
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.hideLoader()
                    }
                    self?.showErrorAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
