//
//  HealthManager.swift
//  HealthKitTutorial
//
//  Created by brian on 2021/05/17.
//

import Foundation
import HealthKit

struct HealthData {
    let startTime: String
    let stepCount: String
}

class HealthManager {
    private init() {}
    private let healthStore = HKHealthStore()

    static let shared = HealthManager()
    
    var dataArray:[HealthData] = []
    

    private func healthKitTypesToRead() -> Set<HKObjectType> {
        guard  let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
               let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
               let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
               let timeWalk = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        
        else { return [] }
        
        let healthKitTypesToRead: Set<HKObjectType> = [stepCount,
                                                       distanceWalkingRunning,
                                                       activeEnergy,
                                                       timeWalk]

        return healthKitTypesToRead
    }
    
    
    func healthKitAuth(completion:@escaping(Bool,HealthKitError?)->()) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false,.healthDataUnavailable)
            return
        }
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead()) { (success, error) in
            if let _ = error {
                completion(success,.requestError)
            } else {
                completion(success,nil)
            }
        }

    }
    
    func stepData (dateString: String, completion: @escaping () -> Void) {
        let df = DateFormatter().customType(.toDate)
        let timeDf = DateFormatter().customType(.toTime)
        
        //걸음수 타입
        let healthkitType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let startDate = df.date(from: dateString)
        let endDate = Date()
        
        //시작시간 ~ 끝시간
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        //어느 간격으로 데이터 가져올래?
        var interval = DateComponents()
        interval.hour = 1
        
        //쿼리가 합쳐서(어느 간격, 여기서는 1시간) 가져오는 쿼리임
        let query = HKStatisticsCollectionQuery.init(quantityType: healthkitType!,
                                                     quantitySamplePredicate: predicate,
                                                     options: .cumulativeSum,
                                                     anchorDate: startDate!,
                                                     intervalComponents: interval)
        query.initialResultsHandler = { [weak self] (query, results, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error :",error)
            }
            results?.enumerateStatistics(from: startDate!, to: endDate) { statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let startTime = statistics.startDate
                    let value = Int(quantity.doubleValue(for: HKUnit.count()))
                    let data = HealthData(startTime: timeDf.string(from: startTime), stepCount: "\(value)")
                    strongSelf.dataArray.append(data)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
            
        }
        healthStore.execute(query)
        
    }
    
    
}

enum HealthKitError:Error {
    case requestError
    case healthDataUnavailable
}
