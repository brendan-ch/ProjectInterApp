// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetRouteInfoDataQuery: GraphQLQuery {
  public static let operationName: String = "GetRouteInfoData"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetRouteInfoData($systemId: ID!, $stopId: ID!, $routeId: ID!) { system(id: $systemId) { __typename route(id: $routeId) { __typename name orderedStop(forStopId: $stopId) { __typename nextStop { __typename stop { __typename name } } } shuttles { __typename eta(forStopId: $stopId) { __typename secondsRemaining } name id } } } }"#
    ))

  public var systemId: ID
  public var stopId: ID
  public var routeId: ID

  public init(
    systemId: ID,
    stopId: ID,
    routeId: ID
  ) {
    self.systemId = systemId
    self.stopId = stopId
    self.routeId = routeId
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "systemId": systemId,
    "stopId": stopId,
    "routeId": routeId
  ] }

  nonisolated public struct Data: ProjectInterOperations.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("system", System?.self, arguments: ["id": .variable("systemId")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GetRouteInfoDataQuery.Data.self
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
        .field("route", Route?.self, arguments: ["id": .variable("routeId")]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetRouteInfoDataQuery.Data.System.self
      ] }

      public var route: Route? { __data["route"] }

      /// System.Route
      ///
      /// Parent Type: `Route`
      nonisolated public struct Route: ProjectInterOperations.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Route }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("orderedStop", OrderedStop?.self, arguments: ["forStopId": .variable("stopId")]),
          .field("shuttles", [Shuttle]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetRouteInfoDataQuery.Data.System.Route.self
        ] }

        public var name: String { __data["name"] }
        public var orderedStop: OrderedStop? { __data["orderedStop"] }
        public var shuttles: [Shuttle]? { __data["shuttles"] }

        /// System.Route.OrderedStop
        ///
        /// Parent Type: `OrderedStop`
        nonisolated public struct OrderedStop: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.OrderedStop }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nextStop", NextStop?.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetRouteInfoDataQuery.Data.System.Route.OrderedStop.self
          ] }

          public var nextStop: NextStop? { __data["nextStop"] }

          /// System.Route.OrderedStop.NextStop
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
              GetRouteInfoDataQuery.Data.System.Route.OrderedStop.NextStop.self
            ] }

            public var stop: Stop? { __data["stop"] }

            /// System.Route.OrderedStop.NextStop.Stop
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
                GetRouteInfoDataQuery.Data.System.Route.OrderedStop.NextStop.Stop.self
              ] }

              public var name: String { __data["name"] }
            }
          }
        }

        /// System.Route.Shuttle
        ///
        /// Parent Type: `Shuttle`
        nonisolated public struct Shuttle: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Shuttle }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("eta", Eta?.self, arguments: ["forStopId": .variable("stopId")]),
            .field("name", String.self),
            .field("id", ProjectInterOperations.ID.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetRouteInfoDataQuery.Data.System.Route.Shuttle.self
          ] }

          public var eta: Eta? { __data["eta"] }
          public var name: String { __data["name"] }
          public var id: ProjectInterOperations.ID { __data["id"] }

          /// System.Route.Shuttle.Eta
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
              GetRouteInfoDataQuery.Data.System.Route.Shuttle.Eta.self
            ] }

            public var secondsRemaining: Double { __data["secondsRemaining"] }
          }
        }
      }
    }
  }
}
