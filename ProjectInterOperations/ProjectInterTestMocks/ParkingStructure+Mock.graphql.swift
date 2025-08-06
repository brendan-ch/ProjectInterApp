// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class ParkingStructure: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.ParkingStructure
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<ParkingStructure>>

  public struct MockFields {
    @Field<Int>("capacity") public var capacity
    @Field<Coordinates>("coordinates") public var coordinates
    @Field<[HistoricalParkingAverageQueryResult]>("historicalAverages") public var historicalAverages
    @Field<ProjectInterOperations.ID>("id") public var id
    @Field<String>("name") public var name
    @Field<Int>("spotsAvailable") public var spotsAvailable
  }
}

public extension Mock where O == ParkingStructure {
  convenience init(
    capacity: Int? = nil,
    coordinates: Mock<Coordinates>? = nil,
    historicalAverages: [Mock<HistoricalParkingAverageQueryResult>]? = nil,
    id: ProjectInterOperations.ID? = nil,
    name: String? = nil,
    spotsAvailable: Int? = nil
  ) {
    self.init()
    _setScalar(capacity, for: \.capacity)
    _setEntity(coordinates, for: \.coordinates)
    _setList(historicalAverages, for: \.historicalAverages)
    _setScalar(id, for: \.id)
    _setScalar(name, for: \.name)
    _setScalar(spotsAvailable, for: \.spotsAvailable)
  }
}
