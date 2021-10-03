//
//  EditingViewController.swift
//  TestTask
//
//  Created by Danil Gerasimov on 03.10.2021.
//

import UIKit
import SQLite

class EditingViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    var table: Table = Table("")
    var id: String = ""
    weak var delegate: LocationListViewControllerDelegate?
    @IBAction func saveButton(_ sender: Any) {
        SQLiteCommands.updateNameInRows(requiredTable: table, newName: nameTextField.text ?? "", id: id)
        delegate?.updateView()
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configure(table: Table, id: String) {
        self.table = table
        self.id = id
    }

}
