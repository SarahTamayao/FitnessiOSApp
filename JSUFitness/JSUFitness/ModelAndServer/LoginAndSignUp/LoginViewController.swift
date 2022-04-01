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
    
    @IBAction func OnloginButton(_ sender: Any) {
    }
    
    @IBAction func OnsignUpButton(_ sender: Any) {
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
