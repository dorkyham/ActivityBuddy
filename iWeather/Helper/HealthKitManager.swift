//
//  HealthKitManager.swift
//  iWeather
//
//  Created by Annisa Nabila Nasution on 22/06/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import Foundation
import HealthKit

struct Step {
    var startDate:Date
    var endDate:Date
    var stepCount:Double
}
class HealthKitManager {
    let storage = HKHealthStore()
    
    func getStepDataAfterRequestAuthorization(completionHandler: @escaping (Int) -> Void) {
    // Access Step Count
        let healthKitTypes: Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ]
    // Check for Authorization
        storage.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if (bool) {
            // Authorization Successful
                self.getTodayStep { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        completionHandler(stepCount)
                    }
                }
            } // end if
        } // end of checking authorization
    }
    
    func getTodayStep(completion: @escaping ((Double) -> Void)){
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: nil, options: [.cumulativeSum],
        anchorDate: startOfDay, intervalComponents: interval)
        
        query.initialResultsHandler = { _, result, error in
                var resultCount = 0.0
                result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in

                if let sum = statistics.sumQuantity() {
                    // Get steps (they are of double type)
                    resultCount = sum.doubleValue(for: HKUnit.count())
                } // end if

                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in

            // If new statistics are available
            if let sum = statistics?.sumQuantity() {
                let resultCount = sum.doubleValue(for: HKUnit.count())
                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            } // end if
        }
        
        storage.execute(query)
    }
    
    func getAllStepsData(completion: @escaping ([Step]) -> Void){
        var stepData : [Step]?
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let exactlySevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: now)!
        let startOfSevenDaysAgo = Calendar.current.startOfDay(for: exactlySevenDaysAgo)
        let predicate = HKQuery.predicateForSamples(withStart: startOfSevenDaysAgo, end: now, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery.init(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum,anchorDate: startOfSevenDaysAgo, intervalComponents: DateComponents(day: 1))

           query.initialResultsHandler = { query, results, error in
               guard let statsCollection = results else {
                   // Perform proper error handling here...
                    fatalError()
               }
                    for stats in statsCollection.statistics() {
                        if let sum = stats.sumQuantity() {
                                   // Get steps (they are of double type)
                            var resultCount = 0.0
                            resultCount = sum.doubleValue(for: HKUnit.count())
                            stepData?.append(Step(startDate: stats.startDate, endDate: stats.endDate, stepCount:resultCount))
                        } // end if
                    }
            
                    DispatchQueue.main.async {
                        completion(stepData!)
                    }
               }
    }
}
    
    

