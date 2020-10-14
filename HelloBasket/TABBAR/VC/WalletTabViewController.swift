//
//  WalletTabViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 07/10/20.
//

import UIKit
import IQKeyboardManagerSwift

class WalletCell : UITableViewCell {
    
    
    @IBOutlet weak var walletBalanceLbl: UILabel!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var oneThousandBtn: UIButton!
    @IBOutlet weak var twoThousandBtn: UIButton!
    @IBOutlet weak var threeThousandBtn: UIButton!
    @IBOutlet weak var addMoneyBtn: UIButton!
    @IBOutlet weak var commonimg: UIImageView!
    @IBOutlet weak var commonBtn: UIButton!
    @IBOutlet weak var commonLbl: UILabel!
    
    
    
    
}

class WalletTabViewController: UIViewController {
    
    var amountField : String?
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var walletTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.backgroundColor = AppColor.themeColor
        
        walletTblView.tableFooterView = UIView()
        
    }
    
    
    
    @objc  func add1000Money() {
        
        amountField = "1000"
        let indexPath = IndexPath(item: 0, section: 0)
        walletTblView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func add2000Money() {
        amountField = "2000"
        let indexPath = IndexPath(item: 0, section: 0)
        walletTblView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func add3000Money(){
        
        amountField = "3000"
        let indexPath = IndexPath(item: 0, section: 0)
        walletTblView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    
}





extension WalletTabViewController {
    
    //MARK:- Side Menu Set up
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as?
            SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = Utils.makeSettings()
    }
    
    
}


extension WalletTabViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "walletBalance") as? WalletCell
        
        if indexPath.section == 0{
            let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "walletBalance") as? WalletCell
            cell?.amountTextfield.text = amountField ?? "0"
            
            return cell!
            
        }
        
       else if indexPath.section == 1{
            let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "rupeesCell") as? WalletCell
        
        cell?.oneThousandBtn.layer.cornerRadius = 5
        cell?.oneThousandBtn.backgroundColor = .none
        cell?.oneThousandBtn.layer.borderColor = UIColor.black.cgColor
        cell?.oneThousandBtn.layer.borderWidth = 1
        
        cell?.twoThousandBtn.layer.cornerRadius = 5
        cell?.twoThousandBtn.backgroundColor = .none
        cell?.twoThousandBtn.layer.borderColor = UIColor.black.cgColor
        cell?.twoThousandBtn.layer.borderWidth = 1
        
        cell?.threeThousandBtn.layer.cornerRadius = 5
        cell?.threeThousandBtn.backgroundColor = .none
        cell?.threeThousandBtn.layer.borderColor = UIColor.black.cgColor
        cell?.threeThousandBtn.layer.borderWidth = 1
        
        cell?.oneThousandBtn.addTarget(self, action: #selector(add1000Money), for: .touchUpInside)
        cell?.twoThousandBtn.addTarget(self, action: #selector(add2000Money), for: .touchUpInside)
        cell?.threeThousandBtn.addTarget(self, action: #selector(add3000Money), for: .touchUpInside)
//
        
        
            
            return cell!
            
        }
        
       else if indexPath.section == 2{
        let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "commonCell") as? WalletCell
        
        if indexPath.row == 0{
            let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "commonCell") as? WalletCell
            
                cell?.commonLbl.text = "Balance History"
                cell?.commonimg.image = UIImage(named: "wallet")
            
            return cell!
            
        }
        
        if indexPath.row == 1{
            let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "commonCell") as? WalletCell
            
            cell?.commonLbl.text = "Cash Back History"
            cell?.commonimg.image = UIImage(named: "walletHistory")
                
            
            return cell!
            
        }
            
        
            
        }
        
        return cell!
    }
    
    
}

extension WalletTabViewController : UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       amountField = textField.text ?? ""
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxCharacters = 4
        
        guard !string.isEmpty else {
            // Backspace detected, allow text change, no need to process the text any further
            return true
        }
        
        // Input Validation
        // Prevent invalid character input, if keyboard is numberpad
        if textField.keyboardType == .numberPad {
            
            // Check for invalid input characters
            if !(CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string))) {
                // Present alert so the user knows what went wrong
                //showAlert(title: "Message", "This field accepts only numeric entries.", goBack: false)
                
                // Invalid characters detected, disallow text change
                return false
            }
            //errorLbl.isHidden = true
            
        }
        
        // Length Processing
        // Need to convert the NSRange to a Swift-appropriate type
        if let text = textField.text, let range = Range(range, in: text) {
            
            let proposedText = text.replacingCharacters(in: range, with: string)
            
            // Check proposed text length does not exceed max character count
            guard proposedText.count <= maxCharacters else {
                
                // Present alert if pasting text
                // easy: pasted data has a length greater than 1; who copy/pastes one character?
                if string.count > 1 {
                    
                    //showAlert(title: "Message", "Paste failed: Maximum character count exceeded.", goBack: false)
                }
                
                // Character count exceeded, disallow text change
                return false
            }
            
            // Only enable the OK/submit button if they have entered all numbers for the last four
            // of their SSN (prevents early submissions/trips to authentication server, etc)
            //            answerButton.isEnabled = (proposedText.count == 4)
        }
        
        // Allow text change
        return true
    }
}
