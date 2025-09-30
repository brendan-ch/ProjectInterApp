//
//  PlaceholderBuildable.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.04.
//

protocol PlaceholderBuildable: AnyObject {
    init(dataInitState: InitializationState)
    static func buildPlaceholder() -> Self
}

extension PlaceholderBuildable where Self: GraphQLQueryable {
    init(dataInitState: InitializationState) {
        self.init(dataInitState: dataInitState)
    }
}
