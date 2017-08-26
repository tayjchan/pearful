//
//  NewExpenseViewController.swift
//  Pearful
//
//  Created by Taylor Chan on 8/18/17.
//  Copyright © 2017 Taylor Chan. All rights reserved.
//

import UIKit

class NewExpenseViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var expenseName: UITextField!
    @IBOutlet weak var expenseCost: UITextField!
    @IBOutlet weak var expenseCategory: UIPickerView!
    
    @IBAction func saveNewExpense(_ sender: UIBarButtonItem) {
        
        let checkIfUserIsSure = UIAlertController (title: "New Budget", message: "Are you sure you want to add an expense \(expenseName.text ?? "Purchase") for \(expenseCost.text ?? "$0.00") into your budget? ", preferredStyle: UIAlertControllerStyle.alert)
        
        let userIsSure = UIAlertAction (title: "Yes", style: UIAlertActionStyle.destructive, handler: nil)
        
        let userNotSure = UIAlertAction (title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        
        checkIfUserIsSure.addAction(userIsSure)
        checkIfUserIsSure.addAction(userNotSure)
        self.present(checkIfUserIsSure, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        if (expenseName == textField) {
            expenseName.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseName.delegate = self
        expenseCost.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
