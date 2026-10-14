// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetAllSystemsQuery: GraphQLQuery {
  public static let operationName: String = "GetAllSystems"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetAllSystems { systems { __typename name id initialRegion { __typename topLeft { __typename latitude longitude } bottomRight { __typename latitude longitude } } } }"#
    ))

  public init() {}

  nonisolated public struct Data: ProjectInterOperations.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("systems", [System].self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GetAllSystemsQuery.Data.self
    ] }

    public var systems: [System] { __data["systems"] }

    /// System
    ///
    /// Parent Type: `System`
    nonisolated public struct System: ProjectInterOperations.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.System }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String.self),
        .field("id", ProjectInterOperations.ID.self),
        .field("initialRegion", InitialRegion?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetAllSystemsQuery.Data.System.self
      ] }

      public var name: String { __data["name"] }
      public var id: ProjectInterOperations.ID { __data["id"] }
      public var initialRegion: InitialRegion? { __data["initialRegion"] }

      /// System.InitialRegion
      ///
      /// Parent Type: `Region`
      nonisolated public struct InitialRegion: ProjectInterOperations.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Region }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("topLeft", TopLeft.self),
          .field("bottomRight", BottomRight.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetAllSystemsQuery.Data.System.InitialRegion.self
        ] }

        public var topLeft: TopLeft { __data["topLeft"] }
        public var bottomRight: BottomRight { __data["bottomRight"] }

        /// System.InitialRegion.TopLeft
        ///
        /// Parent Type: `Coordinates`
        nonisolated public struct TopLeft: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Coordinates }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetAllSystemsQuery.Data.System.InitialRegion.TopLeft.self
          ] }

          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
        }

        /// System.InitialRegion.BottomRight
        ///
        /// Parent Type: `Coordinates`
        nonisolated public struct BottomRight: ProjectInterOperations.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Coordinates }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetAllSystemsQuery.Data.System.InitialRegion.BottomRight.self
          ] }

          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
        }
      }
    }
  }
}
