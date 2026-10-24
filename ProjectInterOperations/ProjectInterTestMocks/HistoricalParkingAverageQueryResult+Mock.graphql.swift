// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
@testable import ProjectInterOperations

nonisolated public final class HistoricalParkingAverageQueryResult: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.HistoricalParkingAverageQueryResult
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<HistoricalParkingAverageQueryResult>>

  public struct MockFields: Sendable {
    @Field<Double>("averageSpotsAvailable") public var averageSpotsAvailable
    @Field<ProjectInterOperations.DateTime>("from") public var from
    @Field<ProjectInterOperations.DateTime>("to") public var to
  }
}

public extension Mock where O == HistoricalParkingAverageQueryResult {
  convenience init(
    averageSpotsAvailable: Double = 0.0,
    from: ProjectInterOperations.DateTime = .defaultMockValue,
    to: ProjectInterOperations.DateTime = .defaultMockValue
  ) {
    self.init()
    _setScalar(averageSpotsAvailable, for: \.averageSpotsAvailable)
    _setScalar(from, for: \.from)
    _setScalar(to, for: \.to)
  }
}
