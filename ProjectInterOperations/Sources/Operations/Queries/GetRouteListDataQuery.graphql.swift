// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetRouteListDataQuery: GraphQLQuery {
  public static let operationName: String = "GetRouteListData"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetRouteListData($systemId: ID!, $stopId: ID!) { system(id: $systemId) { __typename stop(id: $stopId) { __typename name orderedStops { __typename route { __typename id name color shuttles { __typename eta(forStopId: $stopId) { __typename secondsRemaining } } } nextStop { __typename stop { __typename name } } } } } }"#
    ))

  public var systemId: ID
  public var stopId: ID

  public init(
    systemId: ID,
    stopId: ID
  ) {
    self.systemId = systemId
    self.stopId = stopId
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "systemId": systemId,
    "stopId": stopId
  ] }

  nonisolated public struct Data: ProjectInterOperations.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("system", System?.self, arguments: ["id": .variable("systemId")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GetRouteListDataQuery.Data.self
    ] }

    public var system: System? { __data["system"] }

    /// System
    ///
    /// Parent Type: `System`
    nonisolated public struct System: ProjectInterOperations.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.System }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("stop", Stop?.self, arguments: ["id": .variable("stopId")]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetRouteListDataQuery.Data.System.self
      ] }

      public var stop: Stop? { __data["stop"] }

      /// System.Stop
      ///
      /// Parent Type: `Stop`
      nonisolated public struct Stop: ProjectInterOperations.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Stop }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("orderedStops", [OrderedStop]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetRouteListDataQuery.Data.System.Stop.self
        ] }

        public var name: String { __data["name"] }
        public var orderedStops: [OrderedStop]? { __data["orderedStops"] }

        /// System.Stop.OrderedStop
        ///
        /// Parent Type: `OrderedStop`
        nonisolated public struct OrderedStop: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.OrderedStop }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("route", Route?.self),
            .field("nextStop", NextStop?.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetRouteListDataQuery.Data.System.Stop.OrderedStop.self
          ] }

          public var route: Route? { __data["route"] }
          public var nextStop: NextStop? { __data["nextStop"] }

          /// System.Stop.OrderedStop.Route
          ///
          /// Parent Type: `Route`
          nonisolated public struct Route: ProjectInterOperations.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Route }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", ProjectInterOperations.ID.self),
              .field("name", String.self),
              .field("color", String.self),
              .field("shuttles", [Shuttle]?.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GetRouteListDataQuery.Data.System.Stop.OrderedStop.Route.self
            ] }

            public var id: ProjectInterOperations.ID { __data["id"] }
            public var name: String { __data["name"] }
            public var color: String { __data["color"] }
            public var shuttles: [Shuttle]? { __data["shuttles"] }

            /// System.Stop.OrderedStop.Route.Shuttle
            ///
            /// Parent Type: `Shuttle`
            nonisolated public struct Shuttle: ProjectInterOperations.SelectionSet {
              @_spi(Unsafe) public let __data: DataDict
              @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

              @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Shuttle }
              @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("eta", Eta?.self, arguments: ["forStopId": .variable("stopId")]),
              ] }
              @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                GetRouteListDataQuery.Data.System.Stop.OrderedStop.Route.Shuttle.self
              ] }

              public var eta: Eta? { __data["eta"] }

              /// System.Stop.OrderedStop.Route.Shuttle.Eta
              ///
              /// Parent Type: `ETA`
              nonisolated public struct Eta: ProjectInterOperations.SelectionSet {
                @_spi(Unsafe) public let __data: DataDict
                @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

                @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.ETA }
                @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("secondsRemaining", Double.self),
                ] }
                @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                  GetRouteListDataQuery.Data.System.Stop.OrderedStop.Route.Shuttle.Eta.self
                ] }

                public var secondsRemaining: Double { __data["secondsRemaining"] }
              }
            }
          }

          /// System.Stop.OrderedStop.NextStop
          ///
          /// Parent Type: `OrderedStop`
          nonisolated public struct NextStop: ProjectInterOperations.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.OrderedStop }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("stop", Stop?.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GetRouteListDataQuery.Data.System.Stop.OrderedStop.NextStop.self
            ] }

            public var stop: Stop? { __data["stop"] }

            /// System.Stop.OrderedStop.NextStop.Stop
            ///
            /// Parent Type: `Stop`
            nonisolated public struct Stop: ProjectInterOperations.SelectionSet {
              @_spi(Unsafe) public let __data: DataDict
              @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

              @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Stop }
              @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("name", String.self),
              ] }
              @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                GetRouteListDataQuery.Data.System.Stop.OrderedStop.NextStop.Stop.self
              ] }

              public var name: String { __data["name"] }
            }
          }
        }
      }
    }
  }
}
