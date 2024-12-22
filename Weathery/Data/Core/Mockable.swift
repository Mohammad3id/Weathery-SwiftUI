//
//  Mockable.swift
//  Weathery
//
//  Created by Mohammad Eid on 17/12/2024.
//

protocol Mockable {
    associatedtype MockType
    
    static var mock: MockType { get }
    
    static var mockList: [MockType] { get }
}

extension Mockable {
    static var mockList: [MockType] { [] }
}
