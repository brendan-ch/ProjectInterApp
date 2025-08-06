// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class Route: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Route
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Route>>

  public struct MockFields {
    @Field<String>("color") public var color
    @Field<ProjectInterOperations.ID>("id") public var id
    @Field<String>("name") public var name
    @Field<OrderedStop>("orderedStop") public var orderedStop
    @Field<[Coordinates]>("polylineCoordinates") public var polylineCoordinates
    @Field<[Shuttle]>("shuttles") public var shuttles
  }
}

public extension Mock where O == Route {
  convenience init(
    color: String? = nil,
    id: ProjectInterOperations.ID? = nil,
    name: String? = nil,
    orderedStop: Mock<OrderedStop>? = nil,
    polylineCoordinates: [Mock<Coordinates>]? = nil,
    shuttles: [Mock<Shuttle>]? = nil
  ) {
    self.init()
    _setScalar(color, for: \.color)
    _setScalar(id, for: \.id)
    _setScalar(name, for: \.name)
    _setEntity(orderedStop, for: \.orderedStop)
    _setList(polylineCoordinates, for: \.polylineCoordinates)
    _setList(shuttles, for: \.shuttles)
  }
}
