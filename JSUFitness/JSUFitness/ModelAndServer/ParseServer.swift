//
//  ParseServer.swift
//  JSUFitness
//
//  Created by Chao Jiang on 3/28/22.
//

import Foundation
import Parse

struct ParseServerComm {
    
    static func coachSignUp(theCoach: Coach, completion: (()->())? = nil) {
        userSignUp(theUser: theCoach.user) {
            let coach = PFObject(className: "Coach")
            coach["class"] = theCoach.type
            coach["user"] = PFUser.current()!
            coach.saveInBackground { success, error in
                if success {
                    print("successfully saved coach \(theCoach.user.username)")
                    completion?()
                } else {
                    print("failed to save coach: \(theCoach.user.username)")
                }
            }
        }
    }
    
    static func athleteSignUp(theAthlete: Athlete, completion: (()->())? = nil) {
        
    }
    
    
}


//MARK: - private help functions
extension ParseServerComm {
    
    private static func userSignUp(theUser: User, completion: (()->())? = nil) {
        let user = PFUser()
        user.username = theUser.username
        user.password = theUser.password
        user.email = theUser.email
        user["first"] = theUser.firstName
        user["last"] = theUser.lastName
        if let portraitFile = imageConvert(for: theUser.portrait) {
            user["portrait"] = portraitFile
        }
        user["phone"] = theUser.phone
        user.signUpInBackground { success, error in
            if success {
                print("successfully saved user: \(theUser.username)")
                completion?()
            } else {
                print("failed to save user: \(theUser.username)")
            }
        }
    }
    
    private static func imageConvert(for image: UIImage) -> PFFileObject? {
        guard let imageData = image.pngData() else {
            print("Failed to convert image by .pngData()")
            return nil
        }
        let imageFile = PFFileObject(name: "portrait", data: imageData)
        return imageFile
    }
    
}
