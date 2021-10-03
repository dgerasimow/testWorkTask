//
//  EditingViewController.swift
//  TestTask
//
//  Created by Danil Gerasimov on 03.10.2021.
//

import UIKit
import SQLite

protocol RegionViewControllerDelegate: AnyObject {
    func updateView()
}

protocol CityViewControllerDelegate: AnyObject {
    func updateView()
}

class EditingViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    var table: Table = Table("")
    var id: String = ""
    weak var delegate: LocationListViewControllerDelegate?
    weak var regionDelegate: RegionViewControllerDelegate?
    weak var cityDelegate: CityViewControllerDelegate?
    @IBAction func saveButton(_ sender: Any) {
        SQLiteCommands.updateNameInRows(requiredTable: table, newName: nameTextField.text ?? "", id: id)
        delegate?.updateView()
        regionDelegate?.updateView()
        cityDelegate?.updateView()
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
