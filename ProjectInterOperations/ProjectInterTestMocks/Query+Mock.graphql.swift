// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class Query: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Query
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Query>>

  public struct MockFields {
    @Field<Int>("schemaCurrentVersion") public var schemaCurrentVersion
    @Field<Int>("schemaMinVersion") public var schemaMinVersion
    @Field<Int>("secondsThresholdForNotification") public var secondsThresholdForNotification
    @Field<System>("system") public var system
    @Field<[System]>("systems") public var systems
  }
}

public extension Mock where O == Query {
  convenience init(
    schemaCurrentVersion: Int? = nil,
    schemaMinVersion: Int? = nil,
    secondsThresholdForNotification: Int? = nil,
    system: Mock<System>? = nil,
    systems: [Mock<System>]? = nil
  ) {
    self.init()
    _setScalar(schemaCurrentVersion, for: \.schemaCurrentVersion)
    _setScalar(schemaMinVersion, for: \.schemaMinVersion)
    _setScalar(secondsThresholdForNotification, for: \.secondsThresholdForNotification)
    _setEntity(system, for: \.system)
    _setList(systems, for: \.systems)
  }
}
