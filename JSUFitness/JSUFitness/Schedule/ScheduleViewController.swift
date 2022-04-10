//
//  ScheduleViewController.swift
//  JSUFitness
//
//  Created by Chao Jiang on 3/22/22.
//

import UIKit
import FSCalendar
import DropDown

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var scheduleTbView: UITableView!
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstrait: NSLayoutConstraint!
    
    @IBOutlet weak var AddEventButton: UIBarButtonItem!
    
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
    
    //the dropdownmenu
    let dropDownMenu: DropDown = {
        let menu = DropDown()
        let titles = ["New Training", "New Meeting", "New Team", "New Team Member"]
        menu.dataSource = titles
        menu.textColor = .systemBlue
        menu.textFont = .systemFont(ofSize: 15)
        menu.cornerRadius = 5
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scheduleTbView.backgroundColor = .systemFill
        
        setUITableViewDelegateNDataSource()
        setFSCalendarDelegateNDataSource()
        
        //the gesture that user can pull the calendar to change the scope of the calendar
        setCalendarPanGesture()
        
        //add dropdownMenuSelectionAction event
        setUpDropDownMenuSelectionAction()
        
    }
    
    
}

//MARK: - viewWillAppear
extension ScheduleViewController {
    override func viewWillAppear(_ animated: Bool) {
//        schedules.append("abc")
        self.scheduleTbView.reloadData()
        if schedules.count != 0 {
            noScheduleLableLayoutSetup(isHidden: true)
        } else {
            noScheduleLableLayoutSetup(isHidden: false)
        }
    }
}

//MARK: - ScheduleTableView functionality
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setUITableViewDelegateNDataSource() {
        self.scheduleTbView.delegate = self
        self.scheduleTbView.dataSource = self
        scheduleTbView.rowHeight = 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScheduleTableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScheduleDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - No ScheduleView Label View Layout
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

//MARK: - FSCalendar functionality
extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func setFSCalendarDelegateNDataSource() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstrait.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func setCalendarPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(panGesture)
    }

}


//MARK: - Navigationbar items Functionality
extension ScheduleViewController {
    @IBAction func barAddButtonTapped(_ sender: Any) {
        dropDownMenu.anchorView = self.AddEventButton
        dropDownMenu.direction = .bottom
        guard let anchorViewOfDropDown = dropDownMenu.anchorView else {return}
        dropDownMenu.bottomOffset = CGPoint(x: 0, y: anchorViewOfDropDown.plainView.bounds.height)
        self.dropDownMenu.show()
    }
    
    func setUpDropDownMenuSelectionAction() {
        self.dropDownMenu.selectionAction = { index, title in
            print("tapped on row \(index), title: \(title)")
            switch index {
            case 0: return
            case 1: return
            case 2:
                let newVC = NewTeamCreatingViewController()
                self.present(newVC, animated: true, completion: nil)
//                self.navigationItem.backButtonTitle = "Cancel"
            case 3: return
            default: return
            }
        
        }
    }
}
