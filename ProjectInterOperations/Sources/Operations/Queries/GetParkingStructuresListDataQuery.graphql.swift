// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetParkingStructuresListDataQuery: GraphQLQuery {
  public static let operationName: String = "GetParkingStructuresListData"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetParkingStructuresListData($systemId: ID!) { system(id: $systemId) { __typename parkingSystem { __typename parkingStructures { __typename capacity name spotsAvailable id } } } }"#
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
      GetParkingStructuresListDataQuery.Data.self
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
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetParkingStructuresListDataQuery.Data.System.self
      ] }

      public var parkingSystem: ParkingSystem? { __data["parkingSystem"] }

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
          GetParkingStructuresListDataQuery.Data.System.ParkingSystem.self
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
            .field("capacity", Int.self),
            .field("name", String.self),
            .field("spotsAvailable", Int.self),
            .field("id", ProjectInterOperations.ID.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetParkingStructuresListDataQuery.Data.System.ParkingSystem.ParkingStructure.self
          ] }

          public var capacity: Int { __data["capacity"] }
          public var name: String { __data["name"] }
          public var spotsAvailable: Int { __data["spotsAvailable"] }
          public var id: ProjectInterOperations.ID { __data["id"] }
        }
      }
    }
  }
}
