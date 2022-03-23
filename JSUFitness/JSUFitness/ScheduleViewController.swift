//
//  ScheduleViewController.swift
//  JSUFitness
//
//  Created by Chao Jiang on 3/22/22.
//

import UIKit
import FSCalendar

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var scheduleTbView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstrait: NSLayoutConstraint!
    @IBOutlet weak var calendarScopeChangeButton: UIBarButtonItem!
    
    var schedules = [String]()
    
   
    
    let noScheduleLable: UILabel = {
        let lb = UILabel()
        lb.text = "No schedule"
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.font = .boldSystemFont(ofSize: 20)
        lb.textColor = .systemGray
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scheduleTbView.delegate = self
        self.scheduleTbView.dataSource = self
        
        self.scheduleTbView.backgroundColor = .systemFill
        
        calendar.delegate = self
        calendar.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        schedules.append("good day")
        if schedules.count != 0 {
            noScheduleLableLayoutSetup(isHidden: true)
        } else {
            noScheduleLableLayoutSetup(isHidden: false)
        }
    }
    
    
    
}


extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}

extension ScheduleViewController {
    func noScheduleLableLayoutSetup(isHidden: Bool) {
        self.scheduleTbView.addSubview(noScheduleLable)
        noScheduleLable.translatesAutoresizingMaskIntoConstraints = false
        noScheduleLable.isHidden = isHidden
        
        NSLayoutConstraint.activate([
            noScheduleLable.widthAnchor.constraint(equalTo: self.scheduleTbView.widthAnchor, multiplier: 0.7),
            noScheduleLable.heightAnchor.constraint(equalToConstant: 50),
            noScheduleLable.centerXAnchor.constraint(equalTo: scheduleTbView.centerXAnchor),
            noScheduleLable.centerYAnchor.constraint(equalTo: scheduleTbView.centerYAnchor)
        ])
    }
}

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstrait.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    @IBAction func scopeButtonTapped(_ sender: Any) {
        if calendar.scope == .month {
            calendar.setScope(.week, animated: true)
        } else {
            calendar.setScope(.month, animated: true)
        }
    }
}
