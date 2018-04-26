//
//  PassEditViewController.swift
//  PassApp
//
//  Created by cidr5 on 4/17/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import UIKit
import UserNotifications

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
    var passIndex: Int?
    
    // MARK: - Listeners
    
    @IBAction func togglePasswordInputs(_ sender: UIButton) {
        togglePass(passInput.isSecureTextEntry ? .visible : .hidden)
    }
    
    @IBAction func processPassData(_ sender: UIButton) {
        let validationResult = self.validateData()
        if validationResult.type == .ok {
            var passData: PassData
            
            if notificationEditSwitch.isOn {
                passData = PassData(nameInput.text!, passInput.text!, UInt8(timeIntervalControl.selectedSegmentIndex), datePicker.date)
            } else {
                passData = PassData(nameInput.text!, passInput.text!)
            }
            
            save(passData)
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
        if passIndex != nil {
            fillData()
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backAction))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        storage.setPasswords([])
    }
    
    // MARK: - Validation
    
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
    
    // MARK: - Init
    
    private func initDelegates() {
        nameInput.delegate = self
        passInput.delegate = self
        passConfirmInput.delegate = self
    }
    
    private func fillData() {
        guard let pass = storage.getPass(passIndex!) else {return}
        
        nameInput.text = pass.resource
        passInput.text = pass.password
        passConfirmInput.text = pass.password
        if (pass.notificationCountPoint != nil) {
            notificationEditSwitch.isOn = true
            notificationEditView.isHidden = false
            timeIntervalControl.selectedSegmentIndex = Int(pass.intervalSegment!)
            datePicker.date = pass.notificationTime!
        }
    }
    
    // MARK: - Interface
    
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
    
    // MARK: - Data Management
    
    private func save(_ pass: PassData) {
        if passIndex != nil {
            let old = storage.getPass(passIndex!)
            if old != nil {
                let updatedPass = updateNotification(old!, pass)
                storage.updatePass(passIndex!, updatedPass)
            } else {
                saveNewPass(pass)
            }
        } else {
            saveNewPass(pass)
        }
    }
    
    private func saveNewPass(_ pass: PassData) {
        var passToSave = pass
        
        if passToSave.notificationTime != nil {
            passToSave = setNotification(passToSave, nil, nil) ?? passToSave
        }
        storage.savePass(passToSave)
    }
    
    private func comparePasswords(_ p1: PassData, _ p2: PassData) -> ComparePasswordsResult {
        var notificationIsEqual: Bool
        
        if p1.notificationCountPoint == nil && p2.notificationCountPoint != nil {
            notificationIsEqual = false
        } else if p2.notificationCountPoint == nil && p1.notificationCountPoint != nil {
            notificationIsEqual = false
        } else if p1.notificationCountPoint == nil && p2.notificationCountPoint == nil {
            notificationIsEqual = true
        } else {
            notificationIsEqual = p1.notificationCountPoint! == p2.notificationCountPoint!
        }
        
        return ComparePasswordsResult(p1.resource == p2.resource, p1.password == p2.password, notificationIsEqual)
    }
    
    // MARK: - Notifications
    
    private func updateNotification(_ old: PassData, _ new: PassData) -> PassData {
        let comparedPasswords = comparePasswords(old, new)
        var newPass = new
        
        if !comparedPasswords.isEqual {
            if !comparedPasswords.notificationIsEqual {
                let identifier = old.notificationIdentifier
                
                if new.notificationCountPoint == nil {
                    if identifier != nil {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(Config.alertPrefix)\(identifier!)"])
                    }
                } else {
                    if (!comparedPasswords.passwordIsEqual) {
                        if identifier != nil {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(Config.alertPrefix)\(identifier!)"])
                        }
                        
                        newPass = setNotification(newPass, identifier, nil) ?? newPass
                    } else {
                        if identifier != nil {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(Config.alertPrefix)\(identifier!)"])
                        }
                        
                        newPass.notificationCountPoint = old.notificationCountPoint ?? Date()
                        
                        newPass = setNotification(newPass, identifier, getNotificationTime(newPass.intervalSegment!, newPass.notificationTime!, old.notificationCountPoint)) ?? newPass
                    }
                }
            }
        }
        
        return newPass
    }
    
    private func getNotificationTime(_ interval: UInt8, _ time: Date, _ countPoint: Date?) -> DateComponents {
        var dateInfo = DateComponents()
        let intervalDate = (countPoint ?? Date()) + TimeInterval(Config.notificationIntervals[Int(interval)])
        
        dateInfo.year = Calendar.current.component(.year, from: intervalDate)
        dateInfo.month = Calendar.current.component(.month, from: intervalDate)
        dateInfo.day = Calendar.current.component(.day, from: intervalDate)
        dateInfo.hour = Calendar.current.component(.hour, from: time)
        dateInfo.minute = Calendar.current.component(.minute, from: time)
        
        return dateInfo
    }
    
    private func setNotification(_ pass: PassData, _ identifier: UInt?, _ dateParams: DateComponents?) -> PassData? {
        var passToSave = pass
        guard passToSave.intervalSegment != nil && passToSave.notificationTime != nil else {return nil}
        
        passToSave.notificationIdentifier = identifier ?? storage.getLastPassIndex()
        let date = dateParams ?? getNotificationTime(passToSave.intervalSegment!, passToSave.notificationTime!, nil)
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Change password", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "You need to update the password for \(passToSave.resource)", arguments: nil)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        _ = UNNotificationRequest(identifier: "\(Config.alertPrefix)\(storage.getLastPassIndex())", content: content, trigger: trigger)
        
        storage.riseLastPassIndex()
        return passToSave
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
