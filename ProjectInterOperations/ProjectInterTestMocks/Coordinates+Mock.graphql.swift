// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class Coordinates: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Coordinates
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Coordinates>>

  public struct MockFields {
    @Field<Double>("latitude") public var latitude
    @Field<Double>("longitude") public var longitude
  }
}

public extension Mock where O == Coordinates {
  convenience init(
    latitude: Double? = nil,
    longitude: Double? = nil
  ) {
    self.init()
    _setScalar(latitude, for: \.latitude)
    _setScalar(longitude, for: \.longitude)
  }
}
