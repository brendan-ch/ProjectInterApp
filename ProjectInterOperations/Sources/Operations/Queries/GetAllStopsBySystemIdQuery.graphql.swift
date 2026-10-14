// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetAllStopsBySystemIdQuery: GraphQLQuery {
  public static let operationName: String = "GetAllStopsBySystemId"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetAllStopsBySystemId($systemId: ID!) { system(id: $systemId) { __typename stops { __typename name id coordinates { __typename latitude longitude } orderedStops { __typename routeId } } } }"#
    ))

  public var systemId: ID

  public init(systemId: ID) {
    self.systemId = systemId
  }

  @_spi(Unsafe) public var __variables: Variables? { ["systemId": systemId] }

  nonisolated public struct Data: ProjectInterOperations.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("system", System?.self, arguments: ["id": .variable("systemId")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GetAllStopsBySystemIdQuery.Data.self
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
        .field("stops", [Stop]?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetAllStopsBySystemIdQuery.Data.System.self
      ] }

      public var stops: [Stop]? { __data["stops"] }

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
          .field("id", ProjectInterOperations.ID.self),
          .field("coordinates", Coordinates.self),
          .field("orderedStops", [OrderedStop]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetAllStopsBySystemIdQuery.Data.System.Stop.self
        ] }

        public var name: String { __data["name"] }
        public var id: ProjectInterOperations.ID { __data["id"] }
        public var coordinates: Coordinates { __data["coordinates"] }
        public var orderedStops: [OrderedStop]? { __data["orderedStops"] }

        /// System.Stop.Coordinates
        ///
        /// Parent Type: `Coordinates`
        nonisolated public struct Coordinates: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Coordinates }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetAllStopsBySystemIdQuery.Data.System.Stop.Coordinates.self
          ] }

          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
        }

        /// System.Stop.OrderedStop
        ///
        /// Parent Type: `OrderedStop`
        nonisolated public struct OrderedStop: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.OrderedStop }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("routeId", ProjectInterOperations.ID.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetAllStopsBySystemIdQuery.Data.System.Stop.OrderedStop.self
          ] }

          public var routeId: ProjectInterOperations.ID { __data["routeId"] }
        }
      }
    }
  }
}
