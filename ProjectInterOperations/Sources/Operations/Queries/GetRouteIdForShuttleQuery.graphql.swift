// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetRouteIdForShuttleQuery: GraphQLQuery {
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

  @_spi(Unsafe) public var __variables: Variables? { [
    "systemId": systemId,
    "shuttleId": shuttleId
  ] }

  nonisolated public struct Data: ProjectInterOperations.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("system", System?.self, arguments: ["id": .variable("systemId")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GetRouteIdForShuttleQuery.Data.self
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
        .field("shuttle", Shuttle?.self, arguments: ["id": .variable("shuttleId")]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetRouteIdForShuttleQuery.Data.System.self
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
          .field("route", Route?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetRouteIdForShuttleQuery.Data.System.Shuttle.self
        ] }

        public var route: Route? { __data["route"] }

        /// System.Shuttle.Route
        ///
        /// Parent Type: `Route`
        nonisolated public struct Route: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Route }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ProjectInterOperations.ID.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetRouteIdForShuttleQuery.Data.System.Shuttle.Route.self
          ] }

          public var id: ProjectInterOperations.ID { __data["id"] }
        }
      }
    }
  }
}
