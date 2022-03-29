//
//  Model.swift
//  JSUFitness
//
//  Created by Chao Jiang on 3/28/22.
//

import UIKit

struct User {
    var username: String
    var password: String
    var firstName: String
    var lastName: String
    var portrait: UIImage
    var phone: Int
    var email: String
}

struct Coach {
    let user: User
    var type: String
}

struct Athlete {
    let user: User
    var type: String
    var team: Team? = nil
}

struct Team {
    var name: String
    let coach: Coach
}

struct Event {
    var title: String
    var time: Date
    var place: String
    var detail: String
    let coach: Coach
}

struct Attendance {
    var event: Event
    var athlete: Athlete
    var confirmed: Bool
    var hasAbsence: Bool
    var absenceReason: String?
    var absenceApproved: Bool?
}
