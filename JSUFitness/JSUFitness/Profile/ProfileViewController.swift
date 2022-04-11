//
//  ProfileViewController.swift
//  JSUFitness
//
//  Created by Chao Jiang on 3/23/22.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var FirstnameLabel: UILabel!
    @IBOutlet weak var LastnameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func LogoutButton(_ sender: Any) {
        ParseServerComm.userLogout {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = main.instantiateViewController(withIdentifier: "logInPage")
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
            delegate.window?.rootViewController = loginVC
        }
    }
    
    @IBAction func EditButton(_ sender: Any) {
    }
}
