// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class System: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.System
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<System>>

  public struct MockFields {
    @Field<ProjectInterOperations.ID>("id") public var id
    @Field<String>("name") public var name
    @Field<ParkingSystem>("parkingSystem") public var parkingSystem
    @Field<Route>("route") public var route
    @Field<[Route]>("routes") public var routes
    @Field<Shuttle>("shuttle") public var shuttle
    @Field<[Shuttle]>("shuttles") public var shuttles
    @Field<Stop>("stop") public var stop
    @Field<[Stop]>("stops") public var stops
  }
}

public extension Mock where O == System {
  convenience init(
    id: ProjectInterOperations.ID? = nil,
    name: String? = nil,
    parkingSystem: Mock<ParkingSystem>? = nil,
    route: Mock<Route>? = nil,
    routes: [Mock<Route>]? = nil,
    shuttle: Mock<Shuttle>? = nil,
    shuttles: [Mock<Shuttle>]? = nil,
    stop: Mock<Stop>? = nil,
    stops: [Mock<Stop>]? = nil
  ) {
    self.init()
    _setScalar(id, for: \.id)
    _setScalar(name, for: \.name)
    _setEntity(parkingSystem, for: \.parkingSystem)
    _setEntity(route, for: \.route)
    _setList(routes, for: \.routes)
    _setEntity(shuttle, for: \.shuttle)
    _setList(shuttles, for: \.shuttles)
    _setEntity(stop, for: \.stop)
    _setList(stops, for: \.stops)
  }
}
