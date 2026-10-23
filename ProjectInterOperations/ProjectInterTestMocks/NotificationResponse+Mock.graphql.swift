// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

nonisolated public final class NotificationResponse: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.NotificationResponse
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<NotificationResponse>>

  public struct MockFields: Sendable {
    @Field<Notification>("data") public var data
    @Field<String>("message") public var message
    @Field<Bool>("success") public var success
  }
}

public extension Mock where O == NotificationResponse {
  convenience init(
    data: Mock<Notification>? = nil,
    message: String = "",
    success: Bool = false
  ) {
    self.init()
    _setEntity(data, for: \.data)
    _setScalar(message, for: \.message)
    _setScalar(success, for: \.success)
  }
}
