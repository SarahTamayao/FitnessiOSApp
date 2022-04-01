//
//  ParseServer.swift
//  JSUFitness
//
//  Created by Chao Jiang on 3/28/22.
//

import Foundation
import Parse

enum Role: String {
    case Coach = "Coach"
    case Athlete = "Athlete"
}

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
        userSignUp(theUser: theAthlete.user) {
            let athlete = PFObject(className: "Athlete")
            athlete["class"] = theAthlete.type
            athlete["user"] = PFUser.current()!
            athlete.saveInBackground { succeed, error in
                if succeed {
                    print("successfully saved athlete \(theAthlete.user.username)")
                    completion?()
                } else {
                    print("failed to save athlete \(theAthlete.user.username)")
                }
            }
        }
    }
    
    static func coachPostNewEvent(theEvent: Event, athletes: [Athlete], completion: (()->())? = nil) {
        let event = PFObject(className: "Event")
        event["title"] = theEvent.title
        event["time"] = theEvent.time
        event["place"] = theEvent.place
        event["detail"] = theEvent.detail
        getCurrentUserWithRole(role: .Coach) { coach in
            event["coach"] = coach
            event.saveInBackground { succeed, error in
                if succeed {
                    print("The event: \(theEvent.title) successfully created")
                    for athlete in athletes {
                        let athleteEventAttendance = PFObject(className: "AthleteEventAttendance")
                        print("here above with username: \(athlete.user.username)")
                        athleteEventAttendance["event"] = event
                        getAthlete(by: athlete.user.username) { ath in
                            athleteEventAttendance["athlete"] = ath
                            athleteEventAttendance["confirmedByAthlete"] = false
                            athleteEventAttendance.saveInBackground { succeed, error in
                                if succeed {
                                    print ("successfully saved a athleteEventAttendance with event title\(theEvent.title), athlete username: \(athlete.user.username)")
                                } else {
                                    print("failed to save a athleteEventAttendance with event title\(theEvent.title), athlete username: \(athlete.user.username)")
                                }
                            }
                        }
                    }
                    completion?()
                } else {
                    print("failed to create the event: \(theEvent.title)")
                }
            }
        }
        
        
    }
    
}


//MARK: - private help functions
extension ParseServerComm {
    
    private static func userSignUp(theUser: User, succeed: (()->())? = nil) {
        let user = PFUser()
        user.username = theUser.username
        user.password = theUser.password!
        user.email = theUser.email!
        user["first"] = theUser.firstName!
        user["last"] = theUser.lastName!
        if let portraitFile = imageConvert(for: theUser.portrait!) {
            user["portrait"] = portraitFile
        }
        user["phone"] = theUser.phone
        user.signUpInBackground { success, error in
            if success {
                print("successfully saved user: \(theUser.username)")
                succeed?()
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
    
    
    
    private static func getCurrentUserWithRole(role: Role, completion: @escaping (PFObject)->()) {
        let query = PFQuery(className: role.rawValue)
        query.whereKey("user", equalTo: PFUser.current()!)
        query.findObjectsInBackground() { objects, error in
            if let roles = objects {
                if let role = roles.first {
                    print("successfully found current user with role")
                    completion(role)
                }
            } else {
                print("Failed to find \(role.rawValue)")
            }
            
        }
    }
    
    private static func getAthlete(by username: String, completion: @escaping ((PFObject)->())) {
        let innerQuery = PFUser.query()!
        innerQuery.whereKey("username", equalTo: username)
        let query = PFQuery(className: "Athlete")
        query.whereKey("user", matchesQuery: innerQuery)
        print("check")
        query.findObjectsInBackground() { objects, error in
            if let athletes = objects {
                if let athlete = athletes.first {
                    print("successfully found athlete by username: \(username)")
                    completion(athlete)
                } else {
                    print("No athlete has been fount")
                }
            } else {
                print("Failed to find athlete by his/her username: \(username)")
            }
        }
        
    }
    
}
