//
//  PassEditViewController.swift
//  PassApp
//
//  Created by cidr5 on 4/17/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import UIKit

class PassEditViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var nameInput: UITextField!
    
    @IBOutlet weak var passInput: UITextField!
    
    @IBOutlet weak var passConfirmInput: UITextField!
    
    @IBOutlet weak var togglePasswordsBtn: UIButton!
    
    @IBOutlet weak var notificationEditSwitch: UISwitch!
    
    @IBOutlet weak var notificationEditSwitchLabel: UILabel!
    
    @IBOutlet weak var notificationEditView: UIView!
    
    @IBOutlet weak var timeIntervalControl: UISegmentedControl!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Custom Vars
    
    private let intervals = [
        604800, //s (1 week)
        1209600, //s (2 weeks)
        2592000 //s (30 days)
    ]
    private var generator: PassGen
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        self.generator = PassGen()
        
        super.init(coder: coder)
    }
    
    // MARK: - Listeners
    
    @IBAction func togglePasswordInputs(_ sender: UIButton) {
        if passInput.isSecureTextEntry {
            passInput.isSecureTextEntry = false
            passConfirmInput.isSecureTextEntry = false
            togglePasswordsBtn.titleLabel?.text = "Hide"
        } else {
            passInput.isSecureTextEntry = true
            passConfirmInput.isSecureTextEntry = true
            togglePasswordsBtn.titleLabel?.text = "Show"
        }
    }
    
    @IBAction func processPassData(_ sender: UIButton) {
        let validationResult = self.validatePassword(passInput.text!, passConfirmInput.text!)
        if validationResult.type == .error {
           let alert = UIAlertController(title: "Error", message: validationResult.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            var passData: PassData
            
            if notificationEditSwitch.isOn {
                passData = PassData(resource: nameInput.text!, password: passInput.text!, interval: Date() + TimeInterval(intervals[timeIntervalControl.selectedSegmentIndex]), time: datePicker.date)
            } else {
                passData = PassData(resource: nameInput.text!, password: passInput.text!)
            }
            
            
        }
    }
    
    @IBAction func generatePassword(_ sender: UIButton) {
        
    }
    
    @IBAction func toggleNotificationEdit(_ sender: UISwitch) {
        if sender.isOn {
            notificationEditView.isHidden = false
            notificationEditSwitchLabel.text = "Disable notifications"
        } else {
            notificationEditView.isHidden = true
            notificationEditSwitchLabel.text = "Enable notifications"
        }
    }
    
    // MARK: - Lifecycle Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Funcs
    
    func validatePassword(_ password: String, _ confirm: String) -> ValidationResult {
        if (password != confirm) {
            return ValidationResult(type: .error, message: "Paswords in both fields must be the same")
        }
        
        return ValidationResult(type: .ok, message: "")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PassEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
