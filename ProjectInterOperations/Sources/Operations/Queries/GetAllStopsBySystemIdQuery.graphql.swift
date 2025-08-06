// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetAllStopsBySystemIdQuery: GraphQLQuery {
  public static let operationName: String = "GetAllStopsBySystemId"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetAllStopsBySystemId($systemId: ID!) { system(id: $systemId) { __typename stops { __typename name id coordinates { __typename latitude longitude } orderedStops { __typename routeId } } } }"#
    ))

  public var systemId: ID

  public init(systemId: ID) {
    self.systemId = systemId
  }

  public var __variables: Variables? { ["systemId": systemId] }

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
        .field("stops", [Stop]?.self),
      ] }

      public var stops: [Stop]? { __data["stops"] }

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
          .field("id", ProjectInterOperations.ID.self),
          .field("coordinates", Coordinates.self),
          .field("orderedStops", [OrderedStop]?.self),
        ] }

        public var name: String { __data["name"] }
        public var id: ProjectInterOperations.ID { __data["id"] }
        public var coordinates: Coordinates { __data["coordinates"] }
        public var orderedStops: [OrderedStop]? { __data["orderedStops"] }

        /// System.Stop.Coordinates
        ///
        /// Parent Type: `Coordinates`
        public struct Coordinates: ProjectInterOperations.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Coordinates }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
          ] }

          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
        }

        /// System.Stop.OrderedStop
        ///
        /// Parent Type: `OrderedStop`
        public struct OrderedStop: ProjectInterOperations.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.OrderedStop }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("routeId", ProjectInterOperations.ID.self),
          ] }

          public var routeId: ProjectInterOperations.ID { __data["routeId"] }
        }
      }
    }
  }
}
