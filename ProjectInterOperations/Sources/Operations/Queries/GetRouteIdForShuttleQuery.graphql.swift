// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetRouteIdForShuttleQuery: GraphQLQuery {
  public static let operationName: String = "GetRouteIdForShuttle"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetRouteIdForShuttle($systemId: ID!, $shuttleId: ID!) { system(id: $systemId) { __typename shuttle(id: $shuttleId) { __typename route { __typename id } } } }"#
    ))

  public var systemId: ID
  public var shuttleId: ID

  public init(
    systemId: ID,
    shuttleId: ID
  ) {
    self.systemId = systemId
    self.shuttleId = shuttleId
  }

  public var __variables: Variables? { [
    "systemId": systemId,
    "shuttleId": shuttleId
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
        .field("shuttle", Shuttle?.self, arguments: ["id": .variable("shuttleId")]),
      ] }

      public var shuttle: Shuttle? { __data["shuttle"] }

      /// System.Shuttle
      ///
      /// Parent Type: `Shuttle`
      public struct Shuttle: ProjectInterOperations.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Shuttle }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("route", Route?.self),
        ] }

        public var route: Route? { __data["route"] }

        /// System.Shuttle.Route
        ///
        /// Parent Type: `Route`
        public struct Route: ProjectInterOperations.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Route }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ProjectInterOperations.ID.self),
          ] }

          public var id: ProjectInterOperations.ID { __data["id"] }
        }
      }
    }
  }
}
