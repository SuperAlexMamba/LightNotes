//
//  NewNoteController.swift
//  NotesApp
//
//  Created by Слава Орлов on 19.01.2023.
//

import UIKit
import RealmSwift

class NewNoteController: UITableViewController{
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var switcher: UISwitch!
    
    var currentNote: Note?
    let localNotification = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupEditScreen()
        titleTextField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
    }

    @IBAction func cancelController(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        pickerIsHidden(switcher: sender, picker: datePicker)
    }

    func pickerIsHidden(switcher: UISwitch, picker: UIDatePicker){
        if switcher.isOn {picker.isHidden = false}
        else{picker.isHidden = true}
    }
    
    func saveNote() {
        
        let newNote = Note(title: titleTextField.text, descriptionText: descriptionTextView.text, date: datePicker.date)
        
        if currentNote != nil {

            try! realm.write{
                currentNote!.title = newNote.title
                currentNote?.descriptionText = newNote.descriptionText
                currentNote?.date = newNote.date
                currentNote!.notification = newNote.notification
                
                if switcher.isOn == true{
                    currentNote?.notification = true
                    guard let noteTitle = currentNote?.title else {
                        return
                    }
                    localNotification.removePendingNotificationRequests(withIdentifiers: [noteTitle])
                    notificationComplete()
                }
                }
            }
        else{
            StorageManager.saveObject(newNote, swither: self.switcher)
            if newNote.notification == true{
                notificationComplete()
            }
        
        }

        func sendNotifications() {
            
            let content = UNMutableNotificationContent()
            
            content.title = newNote.title
            content.subtitle = (newNote.description)
            content.sound = .defaultCritical
            
            
            let triggerDate = newNote.date!
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month , .day , .hour , .minute, .second], from: triggerDate), repeats: true)
            
            let request = UNNotificationRequest(identifier: newNote.title, content: content, trigger: trigger)
            
            localNotification.add(request)
        }
        
        func notificationComplete() {
            
            localNotification.requestAuthorization(options: [.alert, .badge, .sound]){ granded, error in
                guard granded else {return}
                self.localNotification.getNotificationSettings { (settings) in
                    print(settings)
                    guard settings.authorizationStatus == .authorized else {return}
                }
            }
            sendNotifications()
        }
    }
    
    private func setupView() {
        saveButton.isEnabled = false
        datePicker.minimumDate = .now
        datePicker.isHidden = true
        
        tableView.tableFooterView = UIView()

    }
    
    private func setupEditScreen() {
        if currentNote != nil{
            setupNavigationBar()
            titleTextField.contentMode = .scaleAspectFill
            titleTextField.text = currentNote?.title
            descriptionTextView.text = currentNote?.descriptionText
            datePicker.date = (currentNote?.date)!
            
            if currentNote?.notification == true{
                switcher.isOn = true
                datePicker.isHidden = false
            }
            else{
                switcher.isOn = false
                datePicker.isHidden = true
            }
        }
    }
    
    private func setupNavigationBar() {
        
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
            topItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.5822215676, green: 0.5433937907, blue: 1, alpha: 1)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentNote?.title
        saveButton.isEnabled = true
        saveButton.title = "OK"
    }
}

extension NewNoteController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldAction() {
        if titleTextField.text?.isEmpty == true{
            saveButton.isEnabled = false
        }
        else {
            saveButton.isEnabled = true
        }
    }
}
