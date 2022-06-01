
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewControllerDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet var dobDatePicker: UIDatePicker!
    
    let dobLabelIndexPath = IndexPath(row: 1, section: 0)
    let dobDatePickerIndexPath = IndexPath(row: 2, section: 0)
    
    var isDobDatePickerVisible: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    
    var employeeType: EmployeeType?
    
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
        
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
            dobDatePicker.date = employee.dateOfBirth
            employeeType = employee.employeeType
            
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false && employeeType != nil
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == dobDatePickerIndexPath, isDobDatePickerVisible == false {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == dobDatePickerIndexPath {
            return 190
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == dobLabelIndexPath {
            isDobDatePickerVisible.toggle()
            dobLabel.textColor = .label
            dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
              let employeeType = employeeType else {return}
        
        let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: employeeType)
        
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }

    @IBAction func datePickerValueChanged(_ sender: Any) {
        dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }

    // Delegate from types
    
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
        
        let employeeTypeController = EmployeeTypeTableViewController(coder: coder)
        employeeTypeController?.delegate = self
        employeeTypeController?.employeeType = employeeType
        
        return employeeTypeController
    }
    
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employee: EmployeeType) {
        self.employeeType = employee
        employeeTypeLabel.text = employeeType?.description
        employeeTypeLabel.textColor = .black
        updateSaveButtonState()
    }
}


