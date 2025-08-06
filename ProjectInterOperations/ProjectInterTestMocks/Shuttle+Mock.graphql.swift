// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class Shuttle: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Shuttle
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Shuttle>>

  public struct MockFields {
    @Field<Coordinates>("coordinates") public var coordinates
    @Field<ETA>("eta") public var eta
    @Field<[ETA]>("etas") public var etas
    @Field<ProjectInterOperations.ID>("id") public var id
    @Field<String>("name") public var name
    @Field<Double>("orientationInDegrees") public var orientationInDegrees
    @Field<Route>("route") public var route
  }
}

public extension Mock where O == Shuttle {
  convenience init(
    coordinates: Mock<Coordinates>? = nil,
    eta: Mock<ETA>? = nil,
    etas: [Mock<ETA>]? = nil,
    id: ProjectInterOperations.ID? = nil,
    name: String? = nil,
    orientationInDegrees: Double? = nil,
    route: Mock<Route>? = nil
  ) {
    self.init()
    _setEntity(coordinates, for: \.coordinates)
    _setEntity(eta, for: \.eta)
    _setList(etas, for: \.etas)
    _setScalar(id, for: \.id)
    _setScalar(name, for: \.name)
    _setScalar(orientationInDegrees, for: \.orientationInDegrees)
    _setEntity(route, for: \.route)
  }
}
