//
//  ReportVC.swift
//  Home Budget
//
//  Created by Admin on 24.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import UIKit

class ReportVC: UIViewController {


    @IBOutlet weak var dateFromPicker: UIDatePicker!
    
    @IBOutlet weak var dateToPicker: UIDatePicker!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBAction func chooseCategoryButton(_ sender: Any) {
    }
    
    @IBAction func showReportButton(_ sender: Any) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.performSegue(withIdentifier: "showReportSegue", sender: self)
        })
    }
    
//    var dateFrom = ""
//    
//    var dateTo = ""
    
    var selectedCategory: Category?
    
    func formattDate(datePicker:UIDatePicker) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let stringDate = formatter.string(from: datePicker.date)
        return formatter.date(from: stringDate)!
    }
    
        

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCategorySegue" {
            if let viewController = segue.destination as? CategoryVC {
                viewController.isEnableCell = true
                viewController.selectAction = { selectedCategory in
                    self.selectedCategory = selectedCategory
                    self.categoryLabel.text = selectedCategory.name
     
                }
            }
        }
        if segue.identifier == "showReportSegue" {
            if let viewController = segue.destination as? PieChartReportVC {
                if selectedCategory != nil {
                    viewController.isSelectedCategory = true
                }
                viewController.category = selectedCategory
                viewController.dateFrom = formattDate(datePicker: dateFromPicker)
                viewController.dateTo = formattDate(datePicker: dateToPicker)
            }
        }
     }
}

