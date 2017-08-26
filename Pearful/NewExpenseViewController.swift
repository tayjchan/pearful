//
//  NewExpenseViewController.swift
//  Pearful
//
//  Created by Taylor Chan on 8/18/17.
//  Copyright © 2017 Taylor Chan. All rights reserved.
//

import UIKit
import CoreData

class NewExpenseViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var expenseName: UITextField!
    @IBOutlet weak var expenseCost: UITextField!
    @IBOutlet weak var expenseCategory: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var convertedExpenseCost: Double = 0.0
    var categories = [String]()
    var selectedCategory = ""
    var budgets = [Budget]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func saveNewExpense(_ sender: UIBarButtonItem) {
        
        let checkIfUserIsSure = UIAlertController (title: "New Expense", message: "Are you sure you want to add an expense \(expenseName.text ?? "Purchase") for \(expenseCost.text ?? "$0.00") into your budget \(selectedCategory)? ", preferredStyle: UIAlertControllerStyle.alert)
        
        let userIsSure = UIAlertAction (title: "Yes", style: UIAlertActionStyle.destructive, handler: {
            (_)in
            self.addExpense()
            self.emptyForm()
        })
        
        let userNotSure = UIAlertAction (title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        
        checkIfUserIsSure.addAction(userIsSure)
        checkIfUserIsSure.addAction(userNotSure)
        self.present(checkIfUserIsSure, animated: true, completion: nil)
    }
    
    func emptyForm(){
        expenseName.text = ""
        expenseCost.text = "$"
        selectedCategory = categories[0]
        saveButton.isEnabled = false
        printBudgets()
    }
    
    func printBudgets(){
        do {
            budgets = try context.fetch(Budget.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
            }
        for Budget in budgets {
            print(Budget.name!)
            print(Budget.maxSpend)
            print(Budget.spent)
            print(Budget.leftToSpend)
        }
    }
    
    func convertDollar(from originalInput: String) -> Double {
        var inputAsString = originalInput;
        if let i = inputAsString.characters.index(of: "$") {
            inputAsString.remove(at: i)
        }
        
        return Double(inputAsString) ?? 0
        
    }
    
    func addExpense() {
        convertedExpenseCost = convertDollar(from: expenseCost.text!)
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Budget")
        let predicate = NSPredicate(format: "name = '\(selectedCategory)'")
        fetchRequest.predicate = predicate
        do
        {
            let test = try context.fetch(fetchRequest)
            if test.count == 1
            {
                let objectUpdate = test[0] as! NSManagedObject
                let budget : Budget = test[0] as! Budget
                objectUpdate.setValue(budget.leftToSpend-convertedExpenseCost, forKey: "leftToSpend")
                objectUpdate.setValue(budget.spent+convertedExpenseCost, forKey: "spent")
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        if (expenseName == textField) {
            expenseName.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
    }
    func updateCategories() {
        do {
            budgets = try context.fetch(Budget.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
        
        for budget in budgets {
            categories.append(budget.name ?? "Unknown Budget")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseName.delegate = self
        expenseCost.delegate = self
        self.expenseCategory.delegate = self
        self.expenseCategory.dataSource = self
        
        updateCategories()
        selectedCategory = categories[0]
        saveButton.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selectedCategory = categories[row]
    }

}
