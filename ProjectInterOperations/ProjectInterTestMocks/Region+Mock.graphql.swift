// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
@testable import ProjectInterOperations

nonisolated public final class Region: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Region
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Region>>

  public struct MockFields: Sendable {
    @Field<Coordinates>("bottomRight") public var bottomRight
    @Field<Coordinates>("topLeft") public var topLeft
  }
}

public extension Mock where O == Region {
  convenience init(
    bottomRight: Mock<Coordinates> = Mock<Coordinates>(),
    topLeft: Mock<Coordinates> = Mock<Coordinates>()
  ) {
    self.init()
    _setEntity(bottomRight, for: \.bottomRight)
    _setEntity(topLeft, for: \.topLeft)
  }
}
