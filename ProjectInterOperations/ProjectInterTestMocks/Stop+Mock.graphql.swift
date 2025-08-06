// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class Stop: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Stop
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Stop>>

  public struct MockFields {
    @Field<Coordinates>("coordinates") public var coordinates
    @Field<ProjectInterOperations.ID>("id") public var id
    @Field<String>("name") public var name
    @Field<[OrderedStop]>("orderedStops") public var orderedStops
  }
}

public extension Mock where O == Stop {
  convenience init(
    coordinates: Mock<Coordinates>? = nil,
    id: ProjectInterOperations.ID? = nil,
    name: String? = nil,
    orderedStops: [Mock<OrderedStop>]? = nil
  ) {
    self.init()
    _setEntity(coordinates, for: \.coordinates)
    _setScalar(id, for: \.id)
    _setScalar(name, for: \.name)
    _setList(orderedStops, for: \.orderedStops)
  }
}
