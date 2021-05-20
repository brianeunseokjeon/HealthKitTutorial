//
//  Extension.swift
//  HealthKitTutorial
//
//  Created by brian on 2021/05/20.
//

import Foundation

extension DateFormatter {
    enum CustomDF {
        case toDate
        case toTime
    }
    
    func customType(_ type:CustomDF) -> DateFormatter {
        let df = DateFormatter()
        switch type {
        case .toDate:
            df.dateFormat = "yyyy-MM-dd"
            df.locale = Locale(identifier: "ko_KR")
        case .toTime:
            df.dateFormat = "yyyy-MM-dd HH:mm"
            df.locale = Locale(identifier: "ko_KR")
        }
        return df
    }
        
}
