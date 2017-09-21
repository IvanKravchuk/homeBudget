//
//  DiagramVC.swift
//  Home Budget
//
//  Created by Admin on 19.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import UIKit
import Charts

class DiagramVC: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    
    var months: [String]!
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        barChartView.noDataText = "no data"
        barChartView.noDataText = "GIVE REASON"
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
        "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0,
                         20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(dataPoints: months, values: unitsSold)
        
        barChartView.chartDescription?.text = "Balance"
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<months.count {
//            let dataEntry = BarChartDataEntry(value: unitsSold[i], xIndex: i)
            let dataEntry = BarChartDataEntry(x: Double(i), y: unitsSold[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        
//        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        chartDataSet.colors = ChartColorTemplates.colorful()
        barChartView.xAxis.labelPosition = .bottomInside
        let chartData = BarChartData( dataSet: chartDataSet)
        barChartView.data = chartData
        

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
