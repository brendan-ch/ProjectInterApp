// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
@testable import ProjectInterOperations

nonisolated public final class Notification: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Notification
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Notification>>

  public struct MockFields: Sendable {
    @Field<ProjectInterOperations.ID>("deviceId") public var deviceId
    @Field<ProjectInterOperations.ID>("shuttleId") public var shuttleId
    @Field<ProjectInterOperations.ID>("stopId") public var stopId
  }
}

public extension Mock where O == Notification {
  convenience init(
    deviceId: ProjectInterOperations.ID = "",
    shuttleId: ProjectInterOperations.ID = "",
    stopId: ProjectInterOperations.ID = ""
  ) {
    self.init()
    _setScalar(deviceId, for: \.deviceId)
    _setScalar(shuttleId, for: \.shuttleId)
    _setScalar(stopId, for: \.stopId)
  }
}
