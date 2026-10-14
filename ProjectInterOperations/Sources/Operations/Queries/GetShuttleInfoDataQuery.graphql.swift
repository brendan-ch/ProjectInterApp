// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetShuttleInfoDataQuery: GraphQLQuery {
  public static let operationName: String = "GetShuttleInfoData"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetShuttleInfoData($systemId: ID!, $shuttleId: ID!, $notificationInput: NotificationInput!) { system(id: $systemId) { __typename shuttle(id: $shuttleId) { __typename name etas { __typename stop { __typename name id } secondsRemaining } } } secondsThresholdForNotification(input: $notificationInput) }"#
    ))

  public var systemId: ID
  public var shuttleId: ID
  public var notificationInput: NotificationInput

  public init(
    systemId: ID,
    shuttleId: ID,
    notificationInput: NotificationInput
  ) {
    self.systemId = systemId
    self.shuttleId = shuttleId
    self.notificationInput = notificationInput
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "systemId": systemId,
    "shuttleId": shuttleId,
    "notificationInput": notificationInput
  ] }

  nonisolated public struct Data: ProjectInterOperations.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("system", System?.self, arguments: ["id": .variable("systemId")]),
      .field("secondsThresholdForNotification", Int?.self, arguments: ["input": .variable("notificationInput")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GetShuttleInfoDataQuery.Data.self
    ] }

    public var system: System? { __data["system"] }
    public var secondsThresholdForNotification: Int? { __data["secondsThresholdForNotification"] }

    /// System
    ///
    /// Parent Type: `System`
    nonisolated public struct System: ProjectInterOperations.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.System }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("shuttle", Shuttle?.self, arguments: ["id": .variable("shuttleId")]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetShuttleInfoDataQuery.Data.System.self
      ] }

      public var shuttle: Shuttle? { __data["shuttle"] }

      /// System.Shuttle
      ///
      /// Parent Type: `Shuttle`
      nonisolated public struct Shuttle: ProjectInterOperations.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Shuttle }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("etas", [Eta]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetShuttleInfoDataQuery.Data.System.Shuttle.self
        ] }

        public var name: String { __data["name"] }
        public var etas: [Eta]? { __data["etas"] }

        /// System.Shuttle.Eta
        ///
        /// Parent Type: `ETA`
        nonisolated public struct Eta: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.ETA }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("stop", Stop?.self),
            .field("secondsRemaining", Double.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetShuttleInfoDataQuery.Data.System.Shuttle.Eta.self
          ] }

          public var stop: Stop? { __data["stop"] }
          public var secondsRemaining: Double { __data["secondsRemaining"] }

          /// System.Shuttle.Eta.Stop
          ///
          /// Parent Type: `Stop`
          nonisolated public struct Stop: ProjectInterOperations.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Stop }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String.self),
              .field("id", ProjectInterOperations.ID.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GetShuttleInfoDataQuery.Data.System.Shuttle.Eta.Stop.self
            ] }

            public var name: String { __data["name"] }
            public var id: ProjectInterOperations.ID { __data["id"] }
          }
        }
      }
    }
  }
}
