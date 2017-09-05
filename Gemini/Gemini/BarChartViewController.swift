//
//  BarChartViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 9/3/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//  Taken from StackOverflow
//

import UIKit
import Charts
import Foundation

class BarChartViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    let categories = ["Actual", "Theoretical"]
    var cost = [10.0, 6.8]
    
    /*
     
     Function: set_cost
     --------------------------------
     Loads the total cost based on 
     SAMPLE INTERVAL DATA for now, and then
     sets the values in cost[] to correspond 
     with their labels (0 is current, 1 is
     theoretical).
     
     */
    func set_cost() {
        
        cost[0] = (room?.total_cost())! / 52.0
        
        var theoreticalCost = 0.0
        
        for (_, value) in (room?.models_to_cost)! {
            
            theoreticalCost += value
            
        }
        
        cost[1] = theoreticalCost
    }
    
    /*
     
     Function: donePressed
     --------------------------------
     Saves audit data when done looking at graph
     
     SEGUE~ to ViewController
     
     */
    @IBAction func donePressed(_ sender: Any) {
        
        audit.save_data()
        
    }
    
    /*
     
     Function: didReceiveMemoryWarning
     --------------------------------
     Memory warning. Should clear storage here.
     
     */
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


    /*
     
     Function: viewDidLoad
     --------------------------------
     Loads the view and sets up the Bar Chart View
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set_cost()
        
        barChartView.delegate = self as? ChartViewDelegate
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.chartDescription?.text = "sales vs bought "
        
        
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        
        let xaxis = barChartView.xAxis
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.categories)
        xaxis.granularity = 1
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        
        barChartView.rightAxis.enabled = false
        
        setChart()
    }
    
    /*
     
     Function: viewDidLoad
     --------------------------------
     Loads data and presents it in the bar chart view
     
     */
    func setChart() {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<self.categories.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.cost[i])
            dataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Cost")
        
        let dataSets: [BarChartDataSet] = [chartDataSet]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        //chartDataSet.colors = ChartColorTemplates.colorful()
        //let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartData = BarChartData(dataSets: dataSets)
        
        barChartView.data = chartData
        
        //background color
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //chart animation
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
    }
}
