//
//  ViewBudgetsViewController.swift
//  Pearful
//
//  Created by Taylor Chan on 8/18/17.
//  Copyright © 2017 Taylor Chan. All rights reserved.
//

import UIKit
import Charts

class ViewBudgetsViewController: UIViewController {

    @IBOutlet weak var samplePieGraph: PieChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    var workoutDuration = [String]()
    var beatsPerMin = [String]()
    var budgets = [Budget]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetsCoreData()
        /*for Budget in budgets {
            print(Budget.name!)
            print(Budget.maxSpend)
        }*/
        populateChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAndExit (segue:UIStoryboardSegue) {
        print("Yay, new budget saved!")
    }
    
    func budgetsCoreData(){
        do {
            budgets = try context.fetch(Budget.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
    }
    
    func populateChartData(){
        // need to replace
        var values: [PieChartDataEntry] = []
        let firstBudget = budgets[0]
        firstBudget.spent = 10
        let dataEntry = PieChartDataEntry(value: firstBudget.leftToSpend, label: "$\(firstBudget.leftToSpend) left")
        values.append(dataEntry)
        let dataEntry2 = PieChartDataEntry(value: firstBudget.spent, label: "$\(firstBudget.spent) spent")
        values.append(dataEntry2)
        
        let pieChartDataSet = PieChartDataSet(values: values, label: "\(firstBudget.name ?? "Unknown Budget")")
        pieChartDataSet.sliceSpace = 1
        pieChartDataSet.colors = [UIColor.red, UIColor.green, UIColor.blue]
        
        samplePieGraph.data = PieChartData(dataSet: pieChartDataSet)
       
        
    }
}
