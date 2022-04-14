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
    var altsNeedToAttend:[Athlete] = []
    
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
        detaillabelLayoutSetup(inside: svContentView, below: timeStack)
        detailTextViewLayoutSetup(inside: svContentView, below: detailLabel)
        
        DragDropLayoutSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        print(datePicker.date.formatted(date: .numeric, time: .shortened))
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
        athletesShouldAttendCollectionView.collectionViewLayout = collectionViewLayoutSetup()
        
        athleteLabelLayoutSetup(inside: svContentView, below: detailTextView)
        athleteCollectionViewLayoutSetup(inside: svContentView, below: athletesLabel)
        athletesShouldAttendLabelLayoutSetup(inside: svContentView, below: athleteCollectionView)
        athletesShouldAttendCollectionViewSetup(inside: svContentView, below: athleteShouldAttendLabel)
        okButtonLayoutSetup(inside: svContentView, below: athletesShouldAttendCollectionView)
        
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
//extension NewTeamCreatingViewController: KDDragAndDropCollectionViewDataSource {
//
//
//
//}

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
