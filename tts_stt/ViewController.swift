//
//  ViewController.swift
//  tts_stt
//
//  Created by MacBook on 06/10/25.
//
import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import Combine


class ViewController: UIViewController {

    private var viewModel = AuthViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var labelSignup: UILabel!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUserLoggedIn() {
            self.performSegue(withIdentifier: "TabController", sender: self)
        }
        modifySignInbtn()
        btnGoogle.layer.cornerRadius = 15
        btnGoogle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelSignup.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector( labelTapped))
        labelSignup.addGestureRecognizer(gesture)
        setupBindings()
        
        
        
    }
    @IBAction func getPassword(_ sender: Any) {
    }
    
    @IBAction func getEmail(_ sender: Any) {
    }
    @IBAction func signInClick(_ sender: Any) {
        if (emailField.text?.isEmpty == true){
            return print("Please Enter Email")
        }
        if (passField.text?.isEmpty == true){
            return print("Please Enter Password")
        }
        self.showLoader()
        viewModel.signIn(email: emailField.text!, password: passField.text!)
        //        self.performSegue(withIdentifier: "signup", sender: self)
        //        let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignupViewController
        //        navigationController?.pushViewController(signupVC, animated: true)
    }
    func modifySignInbtn(){
        btnSignIn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnSignIn.layer.cornerRadius = 15
        
    }
    @IBAction func signInWithGoogle(_ sender: Any) {
        showLoader()
        viewModel.signInWithGoogle(presentingViewController: self)
        
        
    }
    
    func isUserLoggedIn() -> Bool {
        
        return Auth.auth().currentUser != nil
        
    }
    
    @objc func labelTapped(){
        self.performSegue(withIdentifier: "signup", sender: self)
    }
    
    private func setupBindings() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                
                if user != nil
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.hideLoader()
                    }
                    self?.performSegue(withIdentifier: "TabController", sender: self)
                    
                }
//                else {
//                    self?.showErrorAlert(message: "Not Sign In")
//                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showErrorAlert(message: errorMessage)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.hideLoader()
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isUserSignIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSigned in
                
                if isSigned == true
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.hideLoader()
                    }
                    self?.showToast(message: "Successfully Log In")
                    self?.performSegue(withIdentifier: "TabController", sender: self)

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
