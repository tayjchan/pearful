//
//  NewBudgetViewController.swift
//  Pearful
//
//  Created by Taylor Chan on 8/18/17.
//  Copyright © 2017 Taylor Chan. All rights reserved.
//

import UIKit
import CoreData

class NewBudgetViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var newBudgetName: UITextField!
    
    @IBOutlet weak var newBudgetMaxSpend: UITextField!
    
    @IBAction func saveNewBudget(_ sender: Any) {
        let convertedNewBudgetMaxSpend = convertDollar(from: newBudgetMaxSpend.text ?? "")
        let checkIfUserIsSure = UIAlertController (title: "New Budget", message: "Are you sure you want to create a budget for \(newBudgetName.text ?? "No name") : \(convertedNewBudgetMaxSpend)", preferredStyle: UIAlertControllerStyle.alert)
        
        let userIsSure = UIAlertAction (title: "Yes", style: UIAlertActionStyle.destructive, handler: {
            (_)in
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let newBudget = Budget (context: context)
                newBudget.name = self.newBudgetName.text!
                newBudget.maxSpend = convertedNewBudgetMaxSpend
                newBudget.leftToSpend = 0.00
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                self.performSegue(withIdentifier: "backToBudgetsSegue", sender: self)
        })
        
        let userNotSure = UIAlertAction (title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        
        checkIfUserIsSure.addAction(userIsSure)
        checkIfUserIsSure.addAction(userNotSure)
        self.present(checkIfUserIsSure, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newBudgetName.delegate = self
        newBudgetMaxSpend.delegate = self
    }
    
    func convertDollar(from originalInput: String) -> Double {
        var inputAsString = originalInput;
        if let i = inputAsString.characters.index(of: "$") {
            inputAsString.remove(at: i)
        }
    
        return Double(inputAsString) ?? 0
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        if (newBudgetName == textField) {
            newBudgetName.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
