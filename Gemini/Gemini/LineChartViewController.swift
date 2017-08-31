//
//  GraphViewController.swift
//  Gemini
//
//  Created by Jordan Rosen-Kaplan on 8/31/17.
//  Copyright © 2017 Jordan Rosen-Kaplan. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController : UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let actualData :[Int : Double] = [
            1 : 123456.0,
            2 : 233456.0,
            3 : 343456.0
        ]
        
        let supposedData :[Int : Double] = [
            1 : 110000.0,
            2 : 190000.0,
            3 : 343321.0
        ]
        
        let theoreticalData :[Int : Double] = [
            1 : 234506.0,
            2 : 213356.0,
            3 : 293436.0
        ]
        
        let ySeries1 = actualData.map { x, y in
            return ChartDataEntry(x: Double(x), y: y)
        }
        
        let ySeries2 = supposedData.map { x, y in
            return ChartDataEntry(x: Double(x), y: y)
        }
        
        let ySeries3 = theoreticalData.map { x, y in
            return ChartDataEntry(x: Double(x), y: y)
        }
        
        let data = LineChartData()
        
        let dataset = LineChartDataSet(values: ySeries1, label: "Actual")
        dataset.colors = [NSUIColor.red]
        data.addDataSet(dataset)
        
        let dataset1 = LineChartDataSet(values: ySeries2, label: "Predicted")
        dataset1.colors = [NSUIColor.blue]
        data.addDataSet(dataset1)
        
        let dataset2 = LineChartDataSet(values: ySeries3, label: "Theoretical")
        dataset2.colors = [NSUIColor.green]
        data.addDataSet(dataset2)
        
        self.lineChartView.data = data
        
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        self.lineChartView.xAxis.drawGridLinesEnabled = false;
        self.lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        self.lineChartView.chartDescription?.text = "Audit Summary"
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        self.lineChartView.animate(xAxisDuration: 4.0, yAxisDuration: 1.0)
    }
}
