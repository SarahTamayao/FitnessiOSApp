//
//  NewTeamCreatingViewController.swift
//  JSUFitness
//
//  Created by Chao Jiang on 4/1/22.
//

import UIKit
import KDDragAndDropCollectionViews

class NewTeamCreatingViewController: UIViewController {
    
    var athletes:[String] = ["a", "b", "c", "d", "e"]
    var newTeamMembers = [String]()
    
    let stackView:UIStackView = {
        let sv = UIStackView()
        sv.clipsToBounds = true
        sv.contentMode = .center
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 5
        return sv
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        lb.text = "Team Name:"
        lb.clipsToBounds = true
        lb.contentMode = .center
        lb.font = .boldSystemFont(ofSize: 25)
        return lb
    }()
    
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.isEnabled = true
        tf.clipsToBounds = true
        tf.textAlignment = .left
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 18)
        return tf
    }()
    
    let okButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
        bt.setTitle("OK", for: .normal)
        return bt
    }()
    
    let athletesLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Athletes"
        lb.font = .boldSystemFont(ofSize: 18)
        lb.textAlignment = .left
        return lb
    }()
    
    let newTeamMembersLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Add to Team"
        lb.font = .boldSystemFont(ofSize: 18)
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
    
    let newTeamMemberCollectionView: KDDragAndDropCollectionView = {
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


//MARK: - viewdidLoad()
extension NewTeamCreatingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.addKeyboardDismissGesture()
        
        viewLayoutSetup()
    }
    
}

extension NewTeamCreatingViewController: KDDragAndDropCollectionViewDataSource {
//MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return athletes.count
        } else {
            return newTeamMembers.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "athleteCell", for: indexPath) as? AthleteCollectionViewCell else {return UICollectionViewCell()}
        if collectionView.tag == 0 {
            cell.fNamelabel.text = athletes[indexPath.row]
        } else {
            cell.fNamelabel.text = newTeamMembers[indexPath.row]
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

//MARK: - KDDragAndDropCollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: IndexPath) {
        if collectionView.tag == 0 {
            athletes.remove(at: indexPath.row)
        } else {
            newTeamMembers.remove(at: indexPath.row)
        }
    }

    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem: AnyObject, atIndexPath indexPath: IndexPath) {
        if let athlete = dataItem as? String {
            if collectionView.tag == 0 {
                athletes.insert(athlete, at: indexPath.row)
            } else {
                newTeamMembers.insert(athlete, at: indexPath.row)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to: IndexPath) {
        if collectionView.tag == 0 {
            move(in: &athletes, from: from.row, to: to.row)
        } else {
            move(in: &newTeamMembers, from: from.row, to: to.row)
        }
    }
    
    func move(in list: inout [String], from iA: Int, to iB: Int) {
        
        print("fromIndex: \(iA)")
        print("toIndex: \(iB)")
        print("count of listA: \(list.count)")
        print("listA: \(list)")
        
        let item = list[iA]
        list.remove(at: iA)
        list.insert(item, at: iB)
    
    }

    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        return collectionView.tag == 0 ? (athletes[indexPath.row] as AnyObject) : (newTeamMembers[indexPath.row] as AnyObject)
    }

    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        guard let athlete = dataItem as? String else {return nil}
        let list = collectionView.tag == 0 ? athletes : newTeamMembers
        for (i, ath) in list.enumerated() {
            if ath != athlete {
                continue
            }
            return IndexPath(row: i, section: 0)
        }
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, cellIsDraggableAtIndexPath indexPath: IndexPath) -> Bool {
        true
    }

    func collectionView(_ collectionView: UICollectionView, cellIsDroppableAtIndexPath indexPath: IndexPath) -> Bool {
        true
    }

}

//MARK: - collectionViewLayoutConfiguration
extension NewTeamCreatingViewController {
    func collectionViewLayoutConfiguration() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        return layout
    }
}

//MARK: - NewTewaCreatingViewController layout setup
extension NewTeamCreatingViewController {
    
    func viewLayoutSetup() {
        athleteCollectionView.dataSource = self
        newTeamMemberCollectionView.dataSource = self
        
        athleteCollectionView.collectionViewLayout = collectionViewLayoutConfiguration()
        newTeamMemberCollectionView.collectionViewLayout = collectionViewLayoutConfiguration()
        
        stackViewlayoutSetup()
        athleteLabelLayoutSetup()
        athleteCollectionViewLayoutSetup()
        newTeamMemberLabelLayoutSetup()
        newTeamCollectionViewLayoutSetup()
        okButtonLayoutSetup()
        
        self.dragAndDropManager = KDDragAndDropManager(canvas: self.view, collectionViews: [athleteCollectionView, newTeamMemberCollectionView])
        
        
    }
    
    func stackViewlayoutSetup() {
        self.view.addSubview(stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.addArrangedSubview(titleTextField)
        
        let guide = UILayoutGuide()
        view.addLayoutGuide(guide)
        NSLayoutConstraint.activate([
            guide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            guide.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func athleteLabelLayoutSetup() {
        view.addSubview(athletesLabel)
        athletesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            athletesLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            athletesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            athletesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            athletesLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func athleteCollectionViewLayoutSetup() {
        self.view.addSubview(athleteCollectionView)
        athleteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            athleteCollectionView.topAnchor.constraint(equalTo: athletesLabel.bottomAnchor, constant: 5),
            athleteCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            athleteCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            athleteCollectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    func newTeamMemberLabelLayoutSetup() {
        view.addSubview(newTeamMembersLabel)
        newTeamMembersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newTeamMembersLabel.topAnchor.constraint(equalTo: athleteCollectionView.bottomAnchor, constant: 20),
            newTeamMembersLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            newTeamMembersLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            newTeamMembersLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func newTeamCollectionViewLayoutSetup() {
        self.view.addSubview(newTeamMemberCollectionView)
        newTeamMemberCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newTeamMemberCollectionView.topAnchor.constraint(equalTo: newTeamMembersLabel.bottomAnchor, constant: 5),
            newTeamMemberCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            newTeamMemberCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            newTeamMemberCollectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    func okButtonLayoutSetup() {
        view.addSubview(okButton)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            okButton.topAnchor.constraint(equalTo: newTeamMemberCollectionView.bottomAnchor, constant: 25),
            okButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
}

//MARK: - Keyboard dismiss gesture
extension NewTeamCreatingViewController {
    func addKeyboardDismissGesture() {
        self.view.addGestureRecognizer(createKeyboardDismissGesture())
    }
    
    func createKeyboardDismissGesture() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(theViewTapped))
        return gesture
    }
    
    @objc func theViewTapped() {
        titleTextField.resignFirstResponder()
    }
}
