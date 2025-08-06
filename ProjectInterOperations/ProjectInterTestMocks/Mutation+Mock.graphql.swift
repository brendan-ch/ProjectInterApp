// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class Mutation: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.Mutation
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Mutation>>

  public struct MockFields {
    @Field<NotificationResponse>("cancelNotification") public var cancelNotification
    @Field<NotificationResponse>("scheduleNotification") public var scheduleNotification
  }
}

public extension Mock where O == Mutation {
  convenience init(
    cancelNotification: Mock<NotificationResponse>? = nil,
    scheduleNotification: Mock<NotificationResponse>? = nil
  ) {
    self.init()
    _setEntity(cancelNotification, for: \.cancelNotification)
    _setEntity(scheduleNotification, for: \.scheduleNotification)
  }
}
