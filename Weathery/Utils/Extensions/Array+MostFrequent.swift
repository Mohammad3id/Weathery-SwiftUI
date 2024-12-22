//
//  Array+MostFrequent.swift
//  Weathery
//
//  Created by Mohammad Eid on 20/12/2024.
//
import Foundation

extension Array where Element: Hashable {
    func mostFrequent() -> Element? {
        var counts = [Element: Int]()
        forEach { counts[$0] = (counts[$0] ?? 0) + 1}
        return counts.max(by: {$0.value < $1.value})?.key
    }
}
