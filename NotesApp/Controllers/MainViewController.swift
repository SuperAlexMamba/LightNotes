//
//  MainViewController.swift
//  NotesApp
//
//  Created by Слава Орлов on 19.01.2023.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    var id: [String] = []
    var didAnimated = false
    var notes: Results<Note>!
    
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes = realm.objects(Note.self)
        
        setupView()
        setupConstraints()
        view.addSubview(menuView)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.isEmpty ? 0 : notes.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        let note = notes[indexPath.row]
        
        cell.titleLabel.text = note.title
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
        startMenuAnimation()
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newNoteVC = segue.source as? NewNoteController else {return}

        newNoteVC.saveNote()
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let note = notes[indexPath.row]
            let newNoteVC = segue.destination as! NewNoteController
            newNoteVC.currentNote = note
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if didAnimated == false{return true}
        else{return false}
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.reloadData()
            let deletedNote = notes[indexPath.row]
            self.id.append(deletedNote.title)
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: self.id)
            StorageManager.deleteNote(deletedNote)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.id.remove(at: 0)
        } 
    }
     
    private func addGesture() {
        let guestRight = UISwipeGestureRecognizer(target: self, action: #selector(startMenuAnimation))
        let guestLeft = UISwipeGestureRecognizer(target: self, action: #selector(startMenuAnimation))
        
        guestLeft.direction = .left
        guestRight.direction = .right

        view.addGestureRecognizer(guestRight)
        view.addGestureRecognizer(guestLeft)
    }
     
    @objc func startMenuAnimation() {
        
        let centerOrigin = menuView.center
        let height = UIScreen.main.bounds.height / 2
        let width = menuView.bounds.width
        
        setupConstraintsInMenuView()
        
        if didAnimated == false {
            self.tableView.isScrollEnabled = false
            UITableView.animate(withDuration: 0.4, delay: 0.0) {
                menuView.center = CGPoint(x: width + centerOrigin.x, y: height)
            }
            self.view.addSubview(backgroundAlpha)
            self.view.insertSubview(backgroundAlpha, belowSubview: menuView)
            didAnimated = true
            addNoteButton.isEnabled = false
        }
        else if didAnimated == true {
            UITableView.animate(withDuration: 0.4, delay: 0.0) {
                menuView.center = CGPoint(x: (width - centerOrigin.x) - width  , y: height)
                backgroundAlpha.removeFromSuperview()
            }
            didAnimated = false
            self.tableView.isScrollEnabled = true
            addNoteButton.isEnabled = true
        }
    }
    
    private func setupView() {
        
        self.title = "Заметки"
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        addNoteButton.layer.cornerRadius = 30
        addNoteButton.clipsToBounds = true
//      addGesture()
    }
    
    private func setupConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        
            addNoteButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -30),
            addNoteButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50),
            addNoteButton.heightAnchor.constraint(equalToConstant: 60),
            addNoteButton.widthAnchor.constraint(equalToConstant: 60)
        
        ])
    }
}
