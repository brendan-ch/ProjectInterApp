// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct HistoricalParkingAverageQueryInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    from: DateTime,
    to: DateTime,
    intervalMs: Int
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

  public var intervalMs: Int {
    get { __data["intervalMs"] }
    set { __data["intervalMs"] = newValue }
  }
}
