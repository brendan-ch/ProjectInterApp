// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetParkingStructuresListDataQuery: GraphQLQuery {
  public static let operationName: String = "GetParkingStructuresListData"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetParkingStructuresListData($systemId: ID!) { system(id: $systemId) { __typename parkingSystem { __typename parkingStructures { __typename capacity name spotsAvailable id } } } }"#
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
          .field("parkingStructures", [ParkingStructure]?.self),
        ] }

        public var parkingStructures: [ParkingStructure]? { __data["parkingStructures"] }

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
