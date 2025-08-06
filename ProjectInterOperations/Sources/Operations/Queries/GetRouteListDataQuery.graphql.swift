// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetRouteListDataQuery: GraphQLQuery {
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

  public var __variables: Variables? { [
    "systemId": systemId,
    "stopId": stopId
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
        .field("stop", Stop?.self, arguments: ["id": .variable("stopId")]),
      ] }

      public var stop: Stop? { __data["stop"] }

      /// System.Stop
      ///
      /// Parent Type: `Stop`
      public struct Stop: ProjectInterOperations.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Stop }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("orderedStops", [OrderedStop]?.self),
        ] }

        public var name: String { __data["name"] }
        public var orderedStops: [OrderedStop]? { __data["orderedStops"] }

        /// System.Stop.OrderedStop
        ///
        /// Parent Type: `OrderedStop`
        public struct OrderedStop: ProjectInterOperations.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.OrderedStop }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("route", Route?.self),
            .field("nextStop", NextStop?.self),
          ] }

          public var route: Route? { __data["route"] }
          public var nextStop: NextStop? { __data["nextStop"] }

          /// System.Stop.OrderedStop.Route
          ///
          /// Parent Type: `Route`
          public struct Route: ProjectInterOperations.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Route }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", ProjectInterOperations.ID.self),
              .field("name", String.self),
              .field("color", String.self),
              .field("shuttles", [Shuttle]?.self),
            ] }

            public var id: ProjectInterOperations.ID { __data["id"] }
            public var name: String { __data["name"] }
            public var color: String { __data["color"] }
            public var shuttles: [Shuttle]? { __data["shuttles"] }

            /// System.Stop.OrderedStop.Route.Shuttle
            ///
            /// Parent Type: `Shuttle`
            public struct Shuttle: ProjectInterOperations.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Shuttle }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("eta", Eta?.self, arguments: ["forStopId": .variable("stopId")]),
              ] }

              public var eta: Eta? { __data["eta"] }

              /// System.Stop.OrderedStop.Route.Shuttle.Eta
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

          /// System.Stop.OrderedStop.NextStop
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

            /// System.Stop.OrderedStop.NextStop.Stop
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
      }
    }
  }
}
