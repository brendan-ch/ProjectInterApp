// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
@testable import ProjectInterOperations

nonisolated public final class Coordinates: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Coordinates
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Coordinates>>

  public struct MockFields: Sendable {
    @Field<Double>("latitude") public var latitude
    @Field<Double>("longitude") public var longitude
  }
}

public extension Mock where O == Coordinates {
  convenience init(
    latitude: Double = 0.0,
    longitude: Double = 0.0
  ) {
    self.init()
    _setScalar(latitude, for: \.latitude)
    _setScalar(longitude, for: \.longitude)
  }
}
