// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetRouteInfoDataQuery: GraphQLQuery {
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

  public var __variables: Variables? { [
    "systemId": systemId,
    "stopId": stopId,
    "routeId": routeId
  ] }

  public struct Data: ProjectInterOperations.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("system", System?.self, arguments: ["id": .variable("systemId")]),
    ] }

    public var system: System? { __data["system"] }

    /// System
    ///
    /// Parent Type: `System`
    public struct System: ProjectInterOperations.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.System }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("route", Route?.self, arguments: ["id": .variable("routeId")]),
      ] }

      public var route: Route? { __data["route"] }

      /// System.Route
      ///
      /// Parent Type: `Route`
      public struct Route: ProjectInterOperations.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Route }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("orderedStop", OrderedStop?.self, arguments: ["forStopId": .variable("stopId")]),
          .field("shuttles", [Shuttle]?.self),
        ] }

        public var name: String { __data["name"] }
        public var orderedStop: OrderedStop? { __data["orderedStop"] }
        public var shuttles: [Shuttle]? { __data["shuttles"] }

        /// System.Route.OrderedStop
        ///
        /// Parent Type: `OrderedStop`
        public struct OrderedStop: ProjectInterOperations.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.OrderedStop }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nextStop", NextStop?.self),
          ] }

          public var nextStop: NextStop? { __data["nextStop"] }

          /// System.Route.OrderedStop.NextStop
          ///
          /// Parent Type: `OrderedStop`
          public struct NextStop: ProjectInterOperations.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.OrderedStop }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("stop", Stop?.self),
            ] }

            public var stop: Stop? { __data["stop"] }

            /// System.Route.OrderedStop.NextStop.Stop
            ///
            /// Parent Type: `Stop`
            public struct Stop: ProjectInterOperations.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Stop }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("name", String.self),
              ] }

              public var name: String { __data["name"] }
            }
          }
        }

        /// System.Route.Shuttle
        ///
        /// Parent Type: `Shuttle`
        public struct Shuttle: ProjectInterOperations.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Shuttle }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("eta", Eta?.self, arguments: ["forStopId": .variable("stopId")]),
            .field("name", String.self),
            .field("id", ProjectInterOperations.ID.self),
          ] }

          public var eta: Eta? { __data["eta"] }
          public var name: String { __data["name"] }
          public var id: ProjectInterOperations.ID { __data["id"] }

          /// System.Route.Shuttle.Eta
          ///
          /// Parent Type: `ETA`
          public struct Eta: ProjectInterOperations.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.ETA }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("secondsRemaining", Double.self),
            ] }

            public var secondsRemaining: Double { __data["secondsRemaining"] }
          }
        }
      }
    }
  }
}
