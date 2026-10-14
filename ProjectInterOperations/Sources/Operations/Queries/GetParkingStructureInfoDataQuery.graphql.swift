// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetParkingStructureInfoDataQuery: GraphQLQuery {
  public static let operationName: String = "GetParkingStructureInfoData"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetParkingStructureInfoData($systemId: ID!, $parkingStructureId: ID!, $historicalAveragesInput: HistoricalParkingAverageQueryInput) { system(id: $systemId) { __typename parkingSystem { __typename parkingStructure(id: $parkingStructureId) { __typename capacity name spotsAvailable id address historicalAverages(input: $historicalAveragesInput) { __typename from to averageSpotsAvailable } } } } }"#
    ))

  public var systemId: ID
  public var parkingStructureId: ID
  public var historicalAveragesInput: GraphQLNullable<HistoricalParkingAverageQueryInput>

  public init(
    systemId: ID,
    parkingStructureId: ID,
    historicalAveragesInput: GraphQLNullable<HistoricalParkingAverageQueryInput>
  ) {
    self.systemId = systemId
    self.parkingStructureId = parkingStructureId
    self.historicalAveragesInput = historicalAveragesInput
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "systemId": systemId,
    "parkingStructureId": parkingStructureId,
    "historicalAveragesInput": historicalAveragesInput
  ] }

  nonisolated public struct Data: ProjectInterOperations.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("system", System?.self, arguments: ["id": .variable("systemId")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GetParkingStructureInfoDataQuery.Data.self
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
        GetParkingStructureInfoDataQuery.Data.System.self
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
          .field("parkingStructure", ParkingStructure?.self, arguments: ["id": .variable("parkingStructureId")]),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetParkingStructureInfoDataQuery.Data.System.ParkingSystem.self
        ] }

        public var parkingStructure: ParkingStructure? { __data["parkingStructure"] }

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
            .field("address", String.self),
            .field("historicalAverages", [HistoricalAverage]?.self, arguments: ["input": .variable("historicalAveragesInput")]),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetParkingStructureInfoDataQuery.Data.System.ParkingSystem.ParkingStructure.self
          ] }

          public var capacity: Int { __data["capacity"] }
          public var name: String { __data["name"] }
          public var spotsAvailable: Int { __data["spotsAvailable"] }
          public var id: ProjectInterOperations.ID { __data["id"] }
          public var address: String { __data["address"] }
          public var historicalAverages: [HistoricalAverage]? { __data["historicalAverages"] }

          /// System.ParkingSystem.ParkingStructure.HistoricalAverage
          ///
          /// Parent Type: `HistoricalParkingAverageQueryResult`
          nonisolated public struct HistoricalAverage: ProjectInterOperations.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.HistoricalParkingAverageQueryResult }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("from", ProjectInterOperations.DateTime.self),
              .field("to", ProjectInterOperations.DateTime.self),
              .field("averageSpotsAvailable", Double.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GetParkingStructureInfoDataQuery.Data.System.ParkingSystem.ParkingStructure.HistoricalAverage.self
            ] }

            public var from: ProjectInterOperations.DateTime { __data["from"] }
            public var to: ProjectInterOperations.DateTime { __data["to"] }
            public var averageSpotsAvailable: Double { __data["averageSpotsAvailable"] }
          }
        }
      }
    }
  }
}
