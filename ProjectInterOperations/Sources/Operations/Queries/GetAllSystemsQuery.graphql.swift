// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetAllSystemsQuery: GraphQLQuery {
  public static let operationName: String = "GetAllSystems"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetAllSystems { systems { __typename name id initialRegion { __typename topLeft { __typename latitude longitude } bottomRight { __typename latitude longitude } } } }"#
    ))

  public init() {}

  public struct Data: ProjectInterOperations.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("systems", [System].self),
    ] }

    public var systems: [System] { __data["systems"] }

    /// System
    ///
    /// Parent Type: `System`
    public struct System: ProjectInterOperations.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.System }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String.self),
        .field("id", ProjectInterOperations.ID.self),
        .field("initialRegion", InitialRegion?.self),
      ] }

      public var name: String { __data["name"] }
      public var id: ProjectInterOperations.ID { __data["id"] }
      public var initialRegion: InitialRegion? { __data["initialRegion"] }

      /// System.InitialRegion
      ///
      /// Parent Type: `Region`
      public struct InitialRegion: ProjectInterOperations.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Region }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("topLeft", TopLeft.self),
          .field("bottomRight", BottomRight.self),
        ] }

        public var topLeft: TopLeft { __data["topLeft"] }
        public var bottomRight: BottomRight { __data["bottomRight"] }

        /// System.InitialRegion.TopLeft
        ///
        /// Parent Type: `Coordinates`
        public struct TopLeft: ProjectInterOperations.SelectionSet {
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

        /// System.InitialRegion.BottomRight
        ///
        /// Parent Type: `Coordinates`
        public struct BottomRight: ProjectInterOperations.SelectionSet {
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
      }
    }
  }
}
