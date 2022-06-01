//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Vladimir Pisarenko on 01.06.2022.
//

import UIKit

protocol EmployeeTypeTableViewControllerDelegate {
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employee: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController  {
    
    
    
    var delegate: EmployeeTypeTableViewControllerDelegate?
    
    var employeeType: EmployeeType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EmployeeType.allCases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeType", for: indexPath)
        
        let type = EmployeeType.allCases[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = type.description
        cell.contentConfiguration = content
        
        if employeeType == type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        employeeType = EmployeeType.allCases[indexPath.row]
        if let employeeTypeSelected = employeeType {
            delegate?.employeeTypeTableViewController(self, didSelect: employeeTypeSelected)
            tableView.reloadData()
        }
    }
}
