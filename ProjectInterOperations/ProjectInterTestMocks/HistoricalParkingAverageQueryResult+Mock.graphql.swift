// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class HistoricalParkingAverageQueryResult: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.HistoricalParkingAverageQueryResult
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<HistoricalParkingAverageQueryResult>>

  public struct MockFields {
    @Field<Double>("averageSpotsAvailable") public var averageSpotsAvailable
    @Field<ProjectInterOperations.DateTime>("from") public var from
    @Field<ProjectInterOperations.DateTime>("to") public var to
  }
}

public extension Mock where O == HistoricalParkingAverageQueryResult {
  convenience init(
    averageSpotsAvailable: Double? = nil,
    from: ProjectInterOperations.DateTime? = nil,
    to: ProjectInterOperations.DateTime? = nil
  ) {
    self.init()
    _setScalar(averageSpotsAvailable, for: \.averageSpotsAvailable)
    _setScalar(from, for: \.from)
    _setScalar(to, for: \.to)
  }
}
