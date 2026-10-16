// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

nonisolated public struct NotificationInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    deviceId: ID,
    shuttleId: ID,
    stopId: ID,
    secondsThreshold: GraphQLNullable<Int32> = nil
  ) {
    __data = InputDict([
      "deviceId": deviceId,
      "shuttleId": shuttleId,
      "stopId": stopId,
      "secondsThreshold": secondsThreshold
    ])
  }

  public var deviceId: ID {
    get { __data["deviceId"] }
    set { __data["deviceId"] = newValue }
  }

  public var shuttleId: ID {
    get { __data["shuttleId"] }
    set { __data["shuttleId"] = newValue }
  }

  public var stopId: ID {
    get { __data["stopId"] }
    set { __data["stopId"] = newValue }
  }

  public var secondsThreshold: GraphQLNullable<Int32> {
    get { __data["secondsThreshold"] }
    set { __data["secondsThreshold"] = newValue }
  }
}
