//
//  Date+Extension.swift
//  GithubFollowers
//
//  Created by Tai Chin Huang on 2022/11/11.
//

import Foundation

extension Date {
    
    func convertDateToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        
        // chose one of the following. example output displayed to the right.

//        dateFormatter.dateStyle    = .full         // Tuesday, March 17, 2015
//        dateFormatter.dateStyle    = .long         // March 17, 2015
//        dateFormatter.dateStyle    = .medium       // Mar 17, 2015
//        dateFormatter.dateStyle    = .short        // Locale="en_US_POSIX" => 4/17/15 --- Local="en_UK" => 17/4/15
                
        dateFormatter.dateFormat   = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
