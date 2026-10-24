// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
@testable import ProjectInterOperations

nonisolated public final class OrderedStop: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.OrderedStop
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<OrderedStop>>

  public struct MockFields: Sendable {
    @Field<OrderedStop>("nextStop") public var nextStop
    @Field<Route>("route") public var route
    @Field<ProjectInterOperations.ID>("routeId") public var routeId
    @Field<Stop>("stop") public var stop
  }
}

public extension Mock where O == OrderedStop {
  convenience init(
    nextStop: Mock<OrderedStop>? = nil,
    route: Mock<Route>? = nil,
    routeId: ProjectInterOperations.ID = "",
    stop: Mock<Stop>? = nil
  ) {
    self.init()
    _setEntity(nextStop, for: \.nextStop)
    _setEntity(route, for: \.route)
    _setScalar(routeId, for: \.routeId)
    _setEntity(stop, for: \.stop)
  }
}
