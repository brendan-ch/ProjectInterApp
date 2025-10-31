// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetParkingStructureInfoDataQuery: GraphQLQuery {
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

  public var __variables: Variables? { [
    "systemId": systemId,
    "parkingStructureId": parkingStructureId,
    "historicalAveragesInput": historicalAveragesInput
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
        .field("parkingSystem", ParkingSystem?.self),
      ] }

      public var parkingSystem: ParkingSystem? { __data["parkingSystem"] }

      /// System.ParkingSystem
      ///
      /// Parent Type: `ParkingSystem`
      public struct ParkingSystem: ProjectInterOperations.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.ParkingSystem }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("parkingStructure", ParkingStructure?.self, arguments: ["id": .variable("parkingStructureId")]),
        ] }

        public var parkingStructure: ParkingStructure? { __data["parkingStructure"] }

        /// System.ParkingSystem.ParkingStructure
        ///
        /// Parent Type: `ParkingStructure`
        public struct ParkingStructure: ProjectInterOperations.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.ParkingStructure }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("capacity", Int.self),
            .field("name", String.self),
            .field("spotsAvailable", Int.self),
            .field("id", ProjectInterOperations.ID.self),
            .field("address", String.self),
            .field("historicalAverages", [HistoricalAverage]?.self, arguments: ["input": .variable("historicalAveragesInput")]),
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
          public struct HistoricalAverage: ProjectInterOperations.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.HistoricalParkingAverageQueryResult }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("from", ProjectInterOperations.DateTime.self),
              .field("to", ProjectInterOperations.DateTime.self),
              .field("averageSpotsAvailable", Double.self),
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
