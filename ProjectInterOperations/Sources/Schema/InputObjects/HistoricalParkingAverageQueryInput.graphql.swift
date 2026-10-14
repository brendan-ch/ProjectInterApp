// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

nonisolated public struct HistoricalParkingAverageQueryInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    from: DateTime,
    to: DateTime,
    intervalMs: Int32
  ) {
    __data = InputDict([
      "from": from,
      "to": to,
      "intervalMs": intervalMs
    ])
  }

  public var from: DateTime {
    get { __data["from"] }
    set { __data["from"] = newValue }
  }

  public var to: DateTime {
    get { __data["to"] }
    set { __data["to"] = newValue }
  }

  public var intervalMs: Int32 {
    get { __data["intervalMs"] }
    set { __data["intervalMs"] = newValue }
  }
}
