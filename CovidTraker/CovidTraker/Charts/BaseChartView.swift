//
//  WeightLineChartView.swift
//  Weight
//
//  Created by Richard Stockdale on 20/02/2019.
//  Copyright © 2019 Junction Seven. All rights reserved.
//

import UIKit
import Charts

struct ChartDataPoint {
    let date: Date
    let value: Float
}

protocol BaseChartViewSelectionDelegate {
    func userSelection(selection: ChartDataPoint?)
}

class BaseChartView: UIView {

    public var selectionDelegate: BaseChartViewSelectionDelegate?
    
    @IBOutlet private var backingView: UIView!
    @IBOutlet private weak var chartView: LineChartView!
    @IBOutlet private weak var infoLabel: UILabel!
    
    var dataPoints: [ChartDataPoint]? {
        // Implement in the sub class
        return nil
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy";
        
        return df
    }()
    
    // MARK: - Data
    
    private func setVisuals(weightDataSet: LineChartDataSet) {
        // Weight set
        weightDataSet.drawCircleHoleEnabled = false
        weightDataSet.circleRadius = 2.0
        weightDataSet.lineWidth = 3.0
        
        if let blue = UIColor(named: "Hightlight") {
            weightDataSet.setCircleColor(blue)
        }
    }
    
    @objc public func updateChart() {
        chartView.delegate = self
        
        infoLabel.text = ""
        infoLabel.isHidden = true
        
        chartView.dragEnabled = true
        chartView.pinchZoomEnabled = true
        chartView.scaleXEnabled = true
        chartView.scaleYEnabled = false
                
        //chartView.leftAxis.valueFormatter = self
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.rightAxis.gridColor = UIColor.clear
        chartView.legend.enabled = false
        
        guard let captures = dataPoints else {
            chartView.isHidden = true
            infoLabel.text = "Could not load chart data"
            infoLabel.isHidden = false
            
            return
        }
        
        if captures.count < 1 {
            chartView.isHidden = true
            infoLabel.text = "No data.\n\nA chart will appear here when you enter your first weight"
            infoLabel.isHidden = false
            
            return
        }
        
        chartView.isHidden = false
        
        setChartValues(dataPoints: captures)
        
        setCustomFeatures()
    }
    
    /// Implemented by the sub class. Use to implement custom behaivour
    public func setCustomFeatures() {}
    
    private func setChartValues(dataPoints: [ChartDataPoint]) {
        var dataEntries: [ChartDataEntry] = []
        
        for dataPoint in dataPoints {
            let date = dataPoint.date
            let value = dataPoint.value
            
            let dataEntry = ChartDataEntry(x: (date.timeIntervalSince1970), y: Double(value))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet.init(entries: dataEntries, label: "Weight Entry")
        let chartData = LineChartData.init(dataSets: [chartDataSet])
        
        chartData.setValueFormatter(self)
        
        chartView.data = chartData
        
        setVisuals(weightDataSet: chartDataSet)
        //setChartYRange()
        setChartXRange()
    }
    
    private func setChartXRange() {
        guard let start = dataPoints?.first?.date else {
            return
        }
        
        // Tomorrow on the right
        let today = Date()
        
        chartView.xAxis.axisMinimum = start.timeIntervalSince1970
        chartView.xAxis.axisMaximum = today.timeIntervalSince1970 + 86400 // One day in seconds
    }
    
//    private func setChartYRange() {
//        // If goal there is no goal we dont need to do anything
//        guard let goal = currentGoal, let last3MonthsOfData = capturesDataSet else {
//            return
//        }
//
//        if last3MonthsOfData.isEmpty {
//            return
//        }
//
//        var lowKg = last3MonthsOfData.first!.weightInKilos
//        var highKg = last3MonthsOfData.first!.weightInKilos
//
//        for capture in last3MonthsOfData {
//            let kg = capture.weightInKilos
//
//            if kg < lowKg {
//                lowKg = kg
//            }
//            else if kg > highKg {
//                highKg = kg
//            }
//        }
//
//        if goal.goalWeightInKg < lowKg {
//            lowKg = goal.goalWeightInKg
//        }
//        else if goal.goalWeightInKg > highKg {
//            highKg = goal.goalWeightInKg
//        }
//
//        // Need a little space above and below the max to ensure we can see all entries
//        let lowBuffer = lowKg / 120
//        let highBuffer = highKg / 120
//
//        chartView.leftAxis.axisMinimum = Double(lowKg - lowBuffer)
//        chartView.leftAxis.axisMaximum = Double(highKg + highBuffer)
//    }
    
    // MARK: - INIT
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
        backingView = Bundle.main.loadNibNamed("BaseChartView", owner: self, options: nil)![0] as? UIView
        backingView?.frame = bounds
        addSubview(backingView!)
        updateChart()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backingView = Bundle.main.loadNibNamed("BaseChartView", owner: self, options: nil)![0] as? UIView
        backingView?.frame = bounds
        addSubview(backingView!)
        updateChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//extension BaseChartView: IAxisValueFormatter {
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return kgToSelectedMetric(kgValue: value)
//    }
//}

extension BaseChartView: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let date = Date.init(timeIntervalSince1970: entry.x)
        let dateString =  dateFormatter.string(from: date)
        
        return dateString
    }
}

extension BaseChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let d = Date.init(timeIntervalSince1970: entry.x)
        
        // Find the capture based on the date
        let captures = dataPoints?.filter({ (c) -> Bool in
            c.date == d
        })
        
        if captures != nil && !captures!.isEmpty {
            if let first = captures?.first {
                selectionDelegate?.userSelection(selection: first)
            }
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        selectionDelegate?.userSelection(selection: nil)
    }
}
