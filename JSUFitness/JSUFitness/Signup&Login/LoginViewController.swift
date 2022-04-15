//
//  LoginViewController.swift
//  JSUFitness
//
//  Created by Xavier Hall on 3/30/22.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var LogoImageView: UIImageView!
    @IBOutlet weak var MyjsuFitnesslabel: UILabel!
    @IBOutlet weak var welcomelabel: UILabel!
    @IBOutlet weak var usernametextfield: UITextField!
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var newAccountlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usernametextfield.becomeFirstResponder()
    }
    //MARK: - Login Button Fuctionality
    @IBAction func OnloginButton(_ sender: Any) {
        
        let user = User(username: usernametextfield.text!, password: passwordtextfield.text!)
        if(self.usernametextfield.text! == "" || self.passwordtextfield.text! == "")
        {
            print("username/password text field is blank")
            return
        }
        ParseServerComm.userLogin(theUser: user) {
            self.performSegue(withIdentifier: "OnLogin", sender: nil)
        } failed: { error in
            if let e = error {
                
                let alertController = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)

                let alertAction = UIAlertAction(title: "OK", style: .default) { action in
                    alertController.dismiss(animated: true)
                }
                alertController.addAction(alertAction)
                
                self.present(alertController, animated: true)
            }
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
