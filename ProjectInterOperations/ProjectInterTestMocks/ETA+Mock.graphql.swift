// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ProjectInterOperations

public class ETA: MockObject {
  public static let objectType: ApolloAPI.Object = ProjectInterOperations.Objects.ETA
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<ETA>>

  public struct MockFields {
    @Field<Double>("secondsRemaining") public var secondsRemaining
    @Field<Stop>("stop") public var stop
  }
}

public extension Mock where O == ETA {
  convenience init(
    secondsRemaining: Double? = nil,
    stop: Mock<Stop>? = nil
  ) {
    self.init()
    _setScalar(secondsRemaining, for: \.secondsRemaining)
    _setEntity(stop, for: \.stop)
  }
}
