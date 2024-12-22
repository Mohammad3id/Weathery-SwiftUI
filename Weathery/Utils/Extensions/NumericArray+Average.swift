//
//  NumberArray-Average.swift
//  Weathery
//
//  Created by Mohammad Eid on 20/12/2024.
//

extension Array<Double> {
    var average: Double { reduce(0, +) / Double(count) }
}

extension Array<Int> {
    var average: Double { Double(reduce(0, +)) / Double(count) }
}

let x = 12
