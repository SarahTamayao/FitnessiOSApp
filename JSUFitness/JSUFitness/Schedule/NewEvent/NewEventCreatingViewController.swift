//
//  NewEventCreatingViewController.swift
//  JSUFitness
//
//  Created by Chao Jiang on 4/12/22.
//

import UIKit
import KDDragAndDropCollectionViews

class NewEventCreatingViewController: UIViewController {
    
    //MARK: Athlete data
    var athletes:[Athlete] = []
    var altsShouldAttend:[Athlete] = []
    var date = Date()
    
    //MARK: ScrollView
    lazy var scrollViewContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 400)
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView(frame: .zero)
        sv.frame = self.view.bounds
        sv.contentSize = scrollViewContentSize
        sv.backgroundColor = .systemBlue
        sv.isScrollEnabled = true
        sv.showsVerticalScrollIndicator = true
        sv.bounces = true
        return sv
    }()
    
    lazy var svContentView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .white
        uv.frame.size = scrollViewContentSize
        return uv
    }()
    
    
    //MARK: Event title
    let eventStack: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    let eventLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Event"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let eventTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "training,meeting,etc..."
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 20)
        return tf
    }()
    
    
    //MARK: Time
    let timeStack: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    let timeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Time"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.date = Date()
        picker.locale = .current
        picker.preferredDatePickerStyle = .compact
        picker.minimumDate = .now
        picker.minuteInterval = 15
        return picker
    }()
    
    //MARK: Place
    let placeStack: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    let placeLabel:UILabel =  {
        let lb = UILabel()
        lb.text = "Place"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let placeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "place to host event"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 20)
        return tf
    }()
    
    //MARK: Event detail
    let detailLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Detail"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let detailTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 20)
        tv.bounces = true
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemFill.cgColor
        tv.layer.cornerRadius = 4
        return tv
    }()
    
    //MARK: Athlete CollectionView
    let okButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
        bt.setTitle("OK", for: .normal)
        return bt
    }()
    
    let athletesLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Athletes"
        lb.font = .boldSystemFont(ofSize: 20)
        lb.textAlignment = .left
        return lb
    }()
    
    let athleteShouldAttendLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Athletes Should Attend"
        lb.font = .boldSystemFont(ofSize: 20)
        lb.textAlignment = .left
        return lb
    }()
    
    let athleteCollectionView: KDDragAndDropCollectionView = {
        let cv = KDDragAndDropCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(AthleteCollectionViewCell.self, forCellWithReuseIdentifier: "athleteCell")
        cv.clipsToBounds = true
        cv.layer.borderWidth = 1
        cv.layer.borderColor = UIColor.systemFill.cgColor
        cv.layer.cornerRadius = 4
        cv.tag = 0
        return cv
    }()
    
    let athletesShouldAttendCollectionView: KDDragAndDropCollectionView = {
        let cv = KDDragAndDropCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(AthleteCollectionViewCell.self, forCellWithReuseIdentifier: "athleteCell")
        cv.clipsToBounds = true
        cv.layer.borderWidth = 1
        cv.layer.borderColor = UIColor.systemFill.cgColor
        cv.layer.cornerRadius = 4
        cv.tag = 1
        return cv
    }()
    
    var dragAndDropManager: KDDragAndDropManager?

}

//MARK: - ViewDidLoad()
extension NewEventCreatingViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(svContentView)
        
        EventStackLayoutSetup(in: svContentView)
        timeStackLayoutSetup(in: svContentView, below: eventStack)
        placeStackLayoutSetup(in: svContentView, below: timeStack)
        detaillabelLayoutSetup(inside: svContentView, below: placeStack)
        detailTextViewLayoutSetup(inside: svContentView, below: detailLabel)
        
        DragDropLayoutSetup()
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        scrollView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ParseServerComm.getAllAthletesPortraitAndFName { athletes in
            self.athletes = athletes
            self.altsShouldAttend = []
            self.athleteCollectionView.reloadData()
            self.athletesShouldAttendCollectionView.reloadData()
        }
    }
}


//MARK: - Layout Setup
extension NewEventCreatingViewController {
    
    
    //MARK: eventStack Layout
    func EventStackLayoutSetup(in fatherView: UIView) {
        fatherView.addSubview(eventStack)
        eventStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventStack.leadingAnchor.constraint(equalTo: fatherView.leadingAnchor, constant: 8),
            eventStack.trailingAnchor.constraint(equalTo: fatherView.trailingAnchor, constant: -8),
            eventStack.heightAnchor.constraint(equalToConstant: 100),
            eventStack.topAnchor.constraint(equalTo: fatherView.topAnchor, constant: 50)
        ])

        let labelView = UIView()
        eventLabelLayoutSetup(inside: labelView)
        eventStack.addArrangedSubview(labelView)
        
        
        let eventTFView = UIView()
        eventTextFieldLayoutSetup(inside: eventTFView)
        eventStack.addArrangedSubview(eventTFView)
    }
    
    func eventLabelLayoutSetup(inside view: UIView) {
        view.addSubview(eventLabel)
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventLabel.topAnchor.constraint(equalTo: view.topAnchor),
            eventLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func eventTextFieldLayoutSetup(inside view: UIView) {
        view.addSubview(eventTextField)
        eventTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            eventTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: timeStark Layout
    func timeStackLayoutSetup(in fatherView: UIView, below topView: UIView) {
        fatherView.addSubview(timeStack)
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeStack.leadingAnchor.constraint(equalTo: fatherView.leadingAnchor, constant: 8),
            timeStack.trailingAnchor.constraint(equalTo: fatherView.trailingAnchor, constant: -8),
            timeStack.heightAnchor.constraint(equalToConstant: 100),
            timeStack.topAnchor.constraint(equalTo: topView.bottomAnchor)
        ])

        let labelView = UIView()
        timeStack.addArrangedSubview(labelView)
        timeLabelLayoutSetup(inside: labelView)
        
        let datePickerView = UIView()
        timeStack.addArrangedSubview(datePickerView)
        datePickerLayoutSetup(inside: datePickerView)
    }
    
    func timeLabelLayoutSetup(inside view: UIView) {
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: view.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func datePickerLayoutSetup(inside view: UIView) {
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func handleDateSelection() {
//        let dateStr = datePicker.date.formatted(.iso8601)
//        print(dateStr)
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        let date = dateFormatter.date(from: dateStr)
//        print(date)
        self.date = datePicker.date

        
    }
    
    //MARK: Place layout
    func placeStackLayoutSetup(in fatherView: UIView, below topView: UIView) {
        fatherView.addSubview(placeStack)
        placeStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeStack.leadingAnchor.constraint(equalTo: fatherView.leadingAnchor, constant: 8),
            placeStack.trailingAnchor.constraint(equalTo: fatherView.trailingAnchor, constant: -8),
            placeStack.heightAnchor.constraint(equalToConstant: 100),
            placeStack.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0)
        ])

        let labelView = UIView()
        placeLabelLayoutSetup(inside: labelView)
        placeStack.addArrangedSubview(labelView)
        
        
        let placeTFView = UIView()
        placeTextFieldLayoutSetup(inside: placeTFView)
        placeStack.addArrangedSubview(placeTFView)
    }
    
    func placeLabelLayoutSetup(inside view: UIView) {
        view.addSubview(placeLabel)
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeLabel.topAnchor.constraint(equalTo: view.topAnchor),
            placeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func placeTextFieldLayoutSetup(inside view: UIView) {
        view.addSubview(placeTextField)
        placeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: detail layout
    func detaillabelLayoutSetup(inside view: UIView, below topView: UIView) {
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            detailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            detailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            detailLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0),
            detailLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func detailTextViewLayoutSetup(inside view: UIView, below topView: UIView) {
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailTextView)
        
        NSLayoutConstraint.activate([
            detailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            detailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            detailTextView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -20),
            detailTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    //MARK: DragAndDropCollectionViewlayoutSetup
    func DragDropLayoutSetup() {
        athleteCollectionView.collectionViewLayout = collectionViewLayoutSetup()
        athleteCollectionView.dataSource = self
        
        athletesShouldAttendCollectionView.collectionViewLayout = collectionViewLayoutSetup()
        athletesShouldAttendCollectionView.dataSource = self
        
        athleteLabelLayoutSetup(inside: svContentView, below: detailTextView)
        athleteCollectionViewLayoutSetup(inside: svContentView, below: athletesLabel)
        athletesShouldAttendLabelLayoutSetup(inside: svContentView, below: athleteCollectionView)
        athletesShouldAttendCollectionViewSetup(inside: svContentView, below: athleteShouldAttendLabel)
        okButtonLayoutSetup(inside: svContentView, below: athletesShouldAttendCollectionView)
        
        dragAndDropManager = KDDragAndDropManager(canvas: self.svContentView, collectionViews: [athleteCollectionView, athletesShouldAttendCollectionView])
        
    }
    
    func athleteLabelLayoutSetup(inside view: UIView, below topView: UIView) {
        athletesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(athletesLabel)
        
        NSLayoutConstraint.activate([
            athletesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            athletesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            athletesLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
            athletesLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func athleteCollectionViewLayoutSetup(inside view: UIView, below topView: UIView) {
        
        athleteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(athleteCollectionView)
        
        NSLayoutConstraint.activate([
            athleteCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            athleteCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            athleteCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0),
            athleteCollectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    func athletesShouldAttendLabelLayoutSetup(inside view: UIView, below topView: UIView) {
        athleteShouldAttendLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(athleteShouldAttendLabel)
        
        NSLayoutConstraint.activate([
            athleteShouldAttendLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            athleteShouldAttendLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            athleteShouldAttendLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0),
            athleteShouldAttendLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    func athletesShouldAttendCollectionViewSetup(inside view: UIView, below topView: UIView) {
        athletesShouldAttendCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(athletesShouldAttendCollectionView)
        
        NSLayoutConstraint.activate([
            athletesShouldAttendCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            athletesShouldAttendCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            athletesShouldAttendCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0),
            athletesShouldAttendCollectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    func okButtonLayoutSetup(inside view: UIView, below topView: UIView) {
        okButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(okButton)
        
        NSLayoutConstraint.activate([
            okButton.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 50),
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}


//MARK: - Drag and Drop collectionView
extension NewEventCreatingViewController: KDDragAndDropCollectionViewDataSource {
    
    
    //MARK: conform UICollectionViewDataSource protocol methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.athletes.count
        } else {
            return self.altsShouldAttend.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "athleteCell", for: indexPath) as? AthleteCollectionViewCell else {return UICollectionViewCell()}
        let dataList:[Athlete] = collectionView.tag == 0 ? athletes : altsShouldAttend
        if let fName = dataList[indexPath.row].user.firstName {
            cell.fNamelabel.text = fName
        }
        if let portraitUrl = dataList[indexPath.row].user.portraitUrl {
            cell.portrait.af.setImage(withURL: portraitUrl)
        }
        
        cell.isHidden = false
        if let kdCollectionView = collectionView as? KDDragAndDropCollectionView {
            if let draggingPathOfCellBeingDragged = kdCollectionView.draggingPathOfCellBeingDragged {
                if draggingPathOfCellBeingDragged.row == indexPath.row {
                    cell.isHidden = true
                }
            }
        }
        return cell
    }
    
    //MARK: comform KDDragAndDropFCollectionViewDataSource protocol methods
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        let dataList = collectionView.tag == 0 ? athletes : altsShouldAttend
        guard let athlete = dataItem as? Athlete else { return nil}
        for (i, ath) in dataList.enumerated() {
            if ath != athlete {
                continue
            }
            return IndexPath(row: i, section: 0)
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: IndexPath) {
        if collectionView.tag == 0 {
            athletes.remove(at: indexPath.row)
        } else {
            altsShouldAttend.remove(at: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem: AnyObject, atIndexPath indexPath: IndexPath) {
        if let athlete = dataItem as? Athlete {
            if collectionView.tag == 0 {
                athletes.insert(athlete, at: indexPath.row)
            } else {
                altsShouldAttend.insert(athlete, at: indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to: IndexPath) {
        if collectionView.tag == 0 {
            move(dataList: &athletes, from: from, to: to)
        } else {
            move(dataList: &altsShouldAttend, from: from, to: to)
        }
        
    }
    
    func move(dataList: inout [Athlete], from: IndexPath, to: IndexPath) {
        let athlete = dataList[from.row]
        dataList.remove(at: from.row)
        dataList.insert(athlete, at: to.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        if collectionView.tag == 0 {
            return athletes[indexPath.row] as AnyObject
        } else {
            return altsShouldAttend[indexPath.row] as AnyObject
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellIsDraggableAtIndexPath indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellIsDroppableAtIndexPath indexPath: IndexPath) -> Bool {
        true
    }


}

//MARK: - Get customized UICollectionViewFlowLayout
extension NewEventCreatingViewController {
    func collectionViewLayoutSetup() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }
}

//MARK: - OKButton functionality
extension NewEventCreatingViewController {
    
    @objc func okButtonTapped() {
        print("okbutton tapped")
        if eventTextField.text?.count == 0 {
            print("Must Have event Title")
            return
        }
        if altsShouldAttend.count == 0 {
            print("Must have at least one athlete to attend the event")
            return
        }
        if placeTextField.text?.count == 0 {
            print("Must have event host place")
        }
        let newEvent = Event(title: eventTextField.text!, time: self.date, place: placeTextField.text!, detail: detailTextView.text)
        ParseServerComm.NewEventPostByCoach(theEvent: newEvent, athletes: altsShouldAttend) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
