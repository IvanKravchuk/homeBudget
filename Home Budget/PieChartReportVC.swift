//
//  PieChartReportVC.swift
//  Home Budget
//
//  Created by Admin on 24.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import UIKit
import Charts

class PieChartReportVC: UIViewController {

    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var reportTableView: UITableView!
    
    var store = DataStore.sharedInstance
    
    var dateFrom:Date?
    
    var dateTo:Date?
    
    var category:Category?
    
    var tableViewData = [Any]()
    
    var isSelectedCategory = false
    
    func getDate(transactions: [Transaction]) -> [String] {
        var dates = [String]()
        for transaction in transactions {
            dates.append( String(describing: transaction.date))
        }
        return dates
    }
    
    func getValues(transactions: [Transaction]) -> [Double] {
        var values = [Double]()
        for transaction in transactions {
            print(transaction.value)
            values.append(transaction.value)
        }
        return values
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Categories")
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
    }
    func calculateSum(transactions: [Transaction]) -> Double{
        var balanceValue: Double = 0.0
        for transaction in transactions {
            if transaction.type {
                balanceValue += transaction.value
            }else{
                balanceValue -= transaction.value
            }
            print(transaction.date)
        }
        return balanceValue
    }
    
    func findIndex(categoriesNames: [String],categoryName: String) -> Int? {
        var result: Int?
        for i in 0..<categoriesNames.count {
            if categoriesNames[i] == categoryName {
                result = i
            }
        }
        return result
    }
    
    func separateTransactionsByCategory(transactions: [Transaction]) -> [Array<Any>] {
        var categoriesNames = [String]()
        var cetegoriesValues = [Double]()
        for i in 0..<transactions.count {
            if categoriesNames.contains( transactions[i].category.name){
                let index = findIndex(categoriesNames: categoriesNames, categoryName: transactions[i].category.name)
                cetegoriesValues[index!] += transactions[i].value
            } else {
                categoriesNames.append(transactions[i].category.name)
                cetegoriesValues.append(transactions[i].value)
            }
        }
        return [categoriesNames,cetegoriesValues]
    }
    
    func transformArray(array: [Array<Any>]) -> [(String,Double)] {
        var tupleArray = [(String,Double)]()
        for i in 0..<array[0].count{
            tupleArray.append((array[0][i] as! String, array[1][i] as! Double))
        }
        return tupleArray
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        reportTableView.dataSource = self
        reportTableView.delegate = self
        if (category != nil && dateTo != nil && dateFrom != nil){
            let filteredData = store.transactions.filter { $0.category.id == category?.id && $0.date <= dateFrom! && $0.date >= dateTo! }
            setChart(dataPoints: getDate(transactions: filteredData), values: getValues(transactions: filteredData))
            sumLabel.text = "Sum : \(calculateSum(transactions: filteredData))"
            tableViewData = filteredData
        }
        if (category == nil && dateTo != nil && dateFrom != nil){
            let filteredData = store.transactions.filter { $0.date >= dateFrom! && $0.date >= dateTo! }
            let separateFilteredData = separateTransactionsByCategory(transactions: filteredData)
            setChart(dataPoints: separateFilteredData[0] as! [String], values: separateFilteredData[1] as! [Double])
            sumLabel.text = "Sum : \(calculateSum(transactions: filteredData))"
            tableViewData = transformArray(array:separateFilteredData)
        }

        
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
//MARK: table view delegate
extension PieChartReportVC : UITableViewDelegate {
    
}

//MARK: table view data source
extension PieChartReportVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reportTableView.dequeueReusableCell(withIdentifier: "reportCell") as! ReportCell
        if isSelectedCategory {
            cell.labelName.text = (self.tableViewData[indexPath.row] as! Transaction).name
            cell.labelValue.text = String((self.tableViewData[indexPath.row] as! Transaction).value)
        } else {
            cell.labelName.text = (self.tableViewData[indexPath.row] as! (String,Double)).0
            cell.labelValue.text = String((self.tableViewData[indexPath.row] as! (String,Double)).1)
        }
        
        //        cell.detailTextLabel?.text = self.store.categories[indexPath.row].Description
        return cell
    }
    
}







