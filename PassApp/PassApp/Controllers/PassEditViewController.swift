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
    
    private let generator = Singleton.passGen
    private let storage = Singleton.storage
    
    // MARK: - Listeners
    
    @IBAction func togglePasswordInputs(_ sender: UIButton) {
        togglePass(passInput.isSecureTextEntry ? .visible : .hidden)
    }
    
    @IBAction func processPassData(_ sender: UIButton) {
        let validationResult = self.validateData()
        if validationResult.type == .ok {
            var passData: PassData
            
            if notificationEditSwitch.isOn {
                passData = PassData(nameInput.text!, passInput.text!, Date() + TimeInterval(Config.notificationIntervals[timeIntervalControl.selectedSegmentIndex]), datePicker.date)
            } else {
                passData = PassData(nameInput.text!, passInput.text!)
            }
            
            storage.savePass(passData)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: validationResult.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func generatePassword(_ sender: UIButton) {
        let pass = generator.generate()
        
        passInput.text = pass
        passConfirmInput.text = pass
        
        togglePass(.visible)
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
        
        initDelegates()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backAction))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        storage.setPasswords([])
    }
    
    // MARK: - Custom Funcs
    
    private func validateData() -> ValidationResult {
        if (nameInput.text == "" || passInput.text == "" || passConfirmInput.text == "") {
            return ValidationResult(type: .error, message: "All text fields must be not empty")
        }
        
        let passValidationResult = validatePassword(passInput.text!, passConfirmInput.text!)
        if (passValidationResult.type == .error) {
            return passValidationResult;
        }
        
        return ValidationResult(type: .ok, message: "")
    }
    
    private func validatePassword(_ password: String, _ confirm: String) -> ValidationResult {
        return password != confirm ? ValidationResult(type: .error, message: "Paswords in both fields must be the same") : ValidationResult(type: .ok, message: "")
    }
    
    private func initDelegates() {
        nameInput.delegate = self
        passInput.delegate = self
        passConfirmInput.delegate = self
    }
    
    private func togglePass(_ state: VisibilityState) {
        passInput.isSecureTextEntry = (state != .visible)
        passConfirmInput.isSecureTextEntry = (state != .visible)
        togglePasswordsBtn.setTitle((state == .visible) ? "Hide" : "Show", for: .normal)
    }
    
    @objc func backAction() {
        let confirmAlert = UIAlertController(title: "Are you sure?", message: "All entered data will be lost after this action.", preferredStyle: .alert)
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {action in self.dismiss(animated: true, completion: nil)}))
        present(confirmAlert, animated: true, completion: nil)
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
        return true
    }
}
