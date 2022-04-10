//
//  SignupViewController.swift
//  JSUFitness
//
//  Created by Chao Jiang on 3/30/22.
//

import UIKit
import AlamofireImage
import DropDown

//MARK: - IBOutlet
class SignupViewController: UIViewController {
    
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var roleChooseSegment: UISegmentedControl!
    var role: Role = .Coach
    var portraitImagePicked = false
    
    @IBOutlet weak var sportsLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var signupScrollView: UIScrollView!
    
    let dropDownMenu: DropDown = {
        let dd = DropDown()
        dd.dataSource = ["Football", "Basketball", "Soccer", "Tennis", "Baseball"]
        dd.textFont = .systemFont(ofSize: 18)
        dd.textColor = .black
        dd.cornerRadius = 5
        return dd
    }()
}
    

//MARK: - ViewDidload()
extension SignupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupScrollView.keyboardDismissMode = .onDrag
        portraitImageView.setToRoundedView()
        
        sportsLabel.layer.cornerRadius = 5
        setupDropDownMenuSelectedAction()
        addSportsLabelGesture()
        
        usernameTextField.textContentType = .oneTimeCode
        passwordTextField.textContentType = .oneTimeCode
        confirmPasswordTextField.textContentType = .oneTimeCode
        
    }

}


//MARK: - Button functionality
extension SignupViewController {
    //add photo
    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        chooseImageSource()
    }
    
    //sign up button
    @IBAction func SignupButtonTapped(_ sender: Any) {
        if(textFieldsAreFilled() && portraitImagePicked && passwordConfirmed() && sportIsChosen()) {
            let user = User(username: usernameTextField.text!,
                            password: passwordTextField.text!,
                            firstName: fNameTextField.text!,
                            lastName: lNameTextField.text!,
                            portrait: portraitImageView.image!,
                            phone: Int(phoneTextField.text!),
                            email: emailTextField.text!)
            
            switch self.role {
            case .Coach:
                let coach = Coach(user: user, type: "basketball")
                ParseServerComm.coachSignUp(theCoach: coach) {
                    self.performSegue(withIdentifier: "signup2Schedule", sender: self)
                }
            case .Athlete:
                let athlete = Athlete(user: user, type: "basketball")
                ParseServerComm.athleteSignUp(theAthlete: athlete) {
                    self.performSegue(withIdentifier: "signup2Schedule", sender: self)
                }
            }
            
        }
    }
    
    //segment 
    @IBAction func roleChosen(_ sender: Any) {
        switch roleChooseSegment.selectedSegmentIndex {
        case 0:
            self.role = .Coach
        case 1:
            self.role = .Athlete
        default:
            return
        }
    }
    
    //textfields check
    func textFieldsAreFilled() -> Bool {
        let requiredInfoTextfields: [UITextField] = [emailTextField,
                                                     usernameTextField,
                                                     passwordTextField,
                                                     confirmPasswordTextField,
                                                     fNameTextField,
                                                     lNameTextField,
                                                     phoneTextField]
        
        for field in requiredInfoTextfields {
            if field.text == "" {
                print("field does not complete")
                return false
            }
        }
        
        return true
    }
    
    //password check
    func passwordConfirmed() -> Bool {
        if let password = passwordTextField.text {
            if let confirmedPassword = confirmPasswordTextField.text {
                return password == confirmedPassword
            }
        }
        return false
    }
    
    func sportIsChosen() -> Bool {
        return sportsLabel.text != "Sports"
    }

}


//MARK: - Add Portrait Functionality
extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImageSource() {
        showPickAlert()
    }
    
    func showPickAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.chooseImage(from: .camera)
        }
        let libraryAction = UIAlertAction(title: "Choose from album", style: .default) { action in
            self.chooseImage(from: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func chooseImage(from source: UIImagePickerController.SourceType) {
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.allowsEditing = true
        switch source {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                pc.sourceType = .camera
                self.present(pc, animated: true)
            } else {
                print("camera is not avaible")
            }
        case .photoLibrary:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                pc.sourceType = .photoLibrary
                self.present(pc, animated: true, completion: nil)
            } else {
                print("Photo library is not avaiable")
            }
        default: return
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info.count)
        guard let portrait = info[.editedImage] as? UIImage else {
            print("failed to collect selected image")
            return
        }
        let size = CGSize(width: 300, height: 300)
        let scaledPortrait = portrait.af.imageAspectScaled(toFill: size, scale: nil)
        self.portraitImageView.image = scaledPortrait
        portraitImagePicked = true
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: - UIImageView setToRoundedView()
extension UIImageView {
    func setToRoundedView() {
        self.layer.cornerRadius = self.frame.width/2.0
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.systemBrown.cgColor
    }
}


//MARK: - DROPDOWN Menu
extension SignupViewController {
    
    func addSportsLabelGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sportsLabelTapped(_:)))
        self.sportsLabel.addGestureRecognizer(gesture)
    }
    
    @objc func sportsLabelTapped(_ sender: Any?) {
        self.dropDownMenu.show()
    }
    func setupDropDownMenuSelectedAction() {
        dropDownMenu.anchorView = self.sportsLabel
        dropDownMenu.direction = .bottom
        guard let anchorViewOfDropDown = dropDownMenu.anchorView else {return}
        dropDownMenu.bottomOffset = CGPoint(x: 0, y: anchorViewOfDropDown.plainView.bounds.height)
        dropDownMenu.selectionAction = { index, title in
                self.sportsLabel.text = title
        }
    }
}
