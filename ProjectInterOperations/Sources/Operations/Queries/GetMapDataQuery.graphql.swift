// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetMapDataQuery: GraphQLQuery {
  public static let operationName: String = "GetMapData"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetMapData($systemId: ID!) { system(id: $systemId) { __typename parkingSystem { __typename parkingStructures { __typename coordinates { __typename latitude longitude } id name } } stops { __typename id name coordinates { __typename latitude longitude } orderedStops { __typename routeId } } shuttles { __typename coordinates { __typename latitude longitude } route { __typename color id } id name orientationInDegrees } routes { __typename polylineCoordinates { __typename latitude longitude } color id } } }"#
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
      GetMapDataQuery.Data.self
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
        .field("parkingSystem", ParkingSystem?.self),
        .field("stops", [Stop]?.self),
        .field("shuttles", [Shuttle]?.self),
        .field("routes", [Route]?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetMapDataQuery.Data.System.self
      ] }

      public var parkingSystem: ParkingSystem? { __data["parkingSystem"] }
      public var stops: [Stop]? { __data["stops"] }
      public var shuttles: [Shuttle]? { __data["shuttles"] }
      public var routes: [Route]? { __data["routes"] }

      /// System.ParkingSystem
      ///
      /// Parent Type: `ParkingSystem`
      nonisolated public struct ParkingSystem: ProjectInterOperations.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.ParkingSystem }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("parkingStructures", [ParkingStructure]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetMapDataQuery.Data.System.ParkingSystem.self
        ] }

        public var parkingStructures: [ParkingStructure]? { __data["parkingStructures"] }

        /// System.ParkingSystem.ParkingStructure
        ///
        /// Parent Type: `ParkingStructure`
        nonisolated public struct ParkingStructure: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.ParkingStructure }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("coordinates", Coordinates.self),
            .field("id", ProjectInterOperations.ID.self),
            .field("name", String.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMapDataQuery.Data.System.ParkingSystem.ParkingStructure.self
          ] }

          public var coordinates: Coordinates { __data["coordinates"] }
          public var id: ProjectInterOperations.ID { __data["id"] }
          public var name: String { __data["name"] }

          /// System.ParkingSystem.ParkingStructure.Coordinates
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
              GetMapDataQuery.Data.System.ParkingSystem.ParkingStructure.Coordinates.self
            ] }

            public var latitude: Double { __data["latitude"] }
            public var longitude: Double { __data["longitude"] }
          }
        }
      }

      /// System.Stop
      ///
      /// Parent Type: `Stop`
      nonisolated public struct Stop: ProjectInterOperations.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Stop }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ProjectInterOperations.ID.self),
          .field("name", String.self),
          .field("coordinates", Coordinates.self),
          .field("orderedStops", [OrderedStop]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetMapDataQuery.Data.System.Stop.self
        ] }

        public var id: ProjectInterOperations.ID { __data["id"] }
        public var name: String { __data["name"] }
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
            GetMapDataQuery.Data.System.Stop.Coordinates.self
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
            GetMapDataQuery.Data.System.Stop.OrderedStop.self
          ] }

          public var routeId: ProjectInterOperations.ID { __data["routeId"] }
        }
      }

      /// System.Shuttle
      ///
      /// Parent Type: `Shuttle`
      nonisolated public struct Shuttle: ProjectInterOperations.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Shuttle }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("coordinates", Coordinates.self),
          .field("route", Route?.self),
          .field("id", ProjectInterOperations.ID.self),
          .field("name", String.self),
          .field("orientationInDegrees", Double.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetMapDataQuery.Data.System.Shuttle.self
        ] }

        public var coordinates: Coordinates { __data["coordinates"] }
        public var route: Route? { __data["route"] }
        public var id: ProjectInterOperations.ID { __data["id"] }
        public var name: String { __data["name"] }
        public var orientationInDegrees: Double { __data["orientationInDegrees"] }

        /// System.Shuttle.Coordinates
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
            GetMapDataQuery.Data.System.Shuttle.Coordinates.self
          ] }

          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
        }

        /// System.Shuttle.Route
        ///
        /// Parent Type: `Route`
        nonisolated public struct Route: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Route }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("color", String.self),
            .field("id", ProjectInterOperations.ID.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMapDataQuery.Data.System.Shuttle.Route.self
          ] }

          public var color: String { __data["color"] }
          public var id: ProjectInterOperations.ID { __data["id"] }
        }
      }

      /// System.Route
      ///
      /// Parent Type: `Route`
      nonisolated public struct Route: ProjectInterOperations.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Route }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("polylineCoordinates", [PolylineCoordinate].self),
          .field("color", String.self),
          .field("id", ProjectInterOperations.ID.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetMapDataQuery.Data.System.Route.self
        ] }

        public var polylineCoordinates: [PolylineCoordinate] { __data["polylineCoordinates"] }
        public var color: String { __data["color"] }
        public var id: ProjectInterOperations.ID { __data["id"] }

        /// System.Route.PolylineCoordinate
        ///
        /// Parent Type: `Coordinates`
        nonisolated public struct PolylineCoordinate: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Coordinates }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMapDataQuery.Data.System.Route.PolylineCoordinate.self
          ] }

          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
        }
      }
    }
  }
}
