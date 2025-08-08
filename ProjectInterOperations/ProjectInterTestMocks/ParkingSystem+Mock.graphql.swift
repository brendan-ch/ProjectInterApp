// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class ParkingSystem: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.ParkingSystem
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<ParkingSystem>>

  public struct MockFields {
    @Field<ParkingStructure>("parkingStructure") public var parkingStructure
    @Field<[ParkingStructure]>("parkingStructures") public var parkingStructures
  }
}

public extension Mock where O == ParkingSystem {
  convenience init(
    parkingStructure: Mock<ParkingStructure>? = nil,
    parkingStructures: [Mock<ParkingStructure>]? = nil
  ) {
    self.init()
    _setEntity(parkingStructure, for: \.parkingStructure)
    _setList(parkingStructures, for: \.parkingStructures)
  }
}
