// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
@testable import ProjectInterOperations

nonisolated public final class Stop: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Stop
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Stop>>

  public struct MockFields: Sendable {
    @Field<Coordinates>("coordinates") public var coordinates
    @Field<ProjectInterOperations.ID>("id") public var id
    @Field<String>("name") public var name
    @Field<[OrderedStop]>("orderedStops") public var orderedStops
  }
}

public extension Mock where O == Stop {
  convenience init(
    coordinates: Mock<Coordinates> = Mock<Coordinates>(),
    id: ProjectInterOperations.ID = "",
    name: String = "",
    orderedStops: [Mock<OrderedStop>]? = nil
  ) {
    self.init()
    _setEntity(coordinates, for: \.coordinates)
    _setScalar(id, for: \.id)
    _setScalar(name, for: \.name)
    _setList(orderedStops, for: \.orderedStops)
  }
}
