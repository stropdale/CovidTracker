//
//  DateRangeChart.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 09/10/2020.
//

import Foundation

class AllTimeChart: BaseChartView {

    var allDataPoints: [ChartDataPoint]?
    
    func dataSet(dataSet: [ChartDataPoint]) {
        allDataPoints = dataSet
    }
    
    override var dataPoints: [ChartDataPoint]? {
        guard let allDataPoints = allDataPoints else {
            return nil
        }
        
        return allDataPoints
    }
}
