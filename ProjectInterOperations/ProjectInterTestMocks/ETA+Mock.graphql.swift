// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
@testable import ProjectInterOperations

nonisolated public final class ETA: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.ETA
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<ETA>>

  public struct MockFields: Sendable {
    @Field<Double>("secondsRemaining") public var secondsRemaining
    @Field<Stop>("stop") public var stop
  }
}

public extension Mock where O == ETA {
  convenience init(
    secondsRemaining: Double = 0.0,
    stop: Mock<Stop>? = nil
  ) {
    self.init()
    _setScalar(secondsRemaining, for: \.secondsRemaining)
    _setEntity(stop, for: \.stop)
  }
}
