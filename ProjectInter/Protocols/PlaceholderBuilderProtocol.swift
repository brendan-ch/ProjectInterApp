//
//  PlaceholderBuilderProtocol.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.06.
//

protocol PlaceholderBuilderProtocol {
    associatedtype PlaceholderType
    
    func build() -> PlaceholderType
}
