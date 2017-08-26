//
//  ViewController.swift
//  Pearful
//
//  Created by Taylor Chan on 8/18/17.
//  Copyright © 2017 Taylor Chan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBAction func resetBudgets(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Budget")
        do
        {
            let budgets = try context.fetch(fetchRequest)
            for budgetObject in budgets{
                let objectUpdate = budgetObject as! NSManagedObject
                let budget : Budget = budgetObject as! Budget
                objectUpdate.setValue(budget.maxSpend, forKey: "leftToSpend")
                objectUpdate.setValue(0, forKey: "spent")
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        }
        catch
        {
            print("ERROR: Can't reset budgets.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

