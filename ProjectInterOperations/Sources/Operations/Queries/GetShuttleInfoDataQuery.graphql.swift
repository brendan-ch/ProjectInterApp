// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetShuttleInfoDataQuery: GraphQLQuery {
  public static let operationName: String = "GetShuttleInfoData"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetShuttleInfoData($systemId: ID!, $shuttleId: ID!, $notificationInput: NotificationInput!) { system(id: $systemId) { __typename shuttle(id: $shuttleId) { __typename name etas { __typename stop { __typename name id } secondsRemaining } } } secondsThresholdForNotification(input: $notificationInput) }"#
    ))

  public var systemId: ID
  public var shuttleId: ID
  public var notificationInput: NotificationInput

  public init(
    systemId: ID,
    shuttleId: ID,
    notificationInput: NotificationInput
  ) {
    self.systemId = systemId
    self.shuttleId = shuttleId
    self.notificationInput = notificationInput
  }

  public var __variables: Variables? { [
    "systemId": systemId,
    "shuttleId": shuttleId,
    "notificationInput": notificationInput
  ] }

  public struct Data: ProjectInterOperations.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("system", System?.self, arguments: ["id": .variable("systemId")]),
      .field("secondsThresholdForNotification", Int?.self, arguments: ["input": .variable("notificationInput")]),
    ] }

    public var system: System? { __data["system"] }
    public var secondsThresholdForNotification: Int? { __data["secondsThresholdForNotification"] }

    /// System
    ///
    /// Parent Type: `System`
    public struct System: ProjectInterOperations.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.System }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("shuttle", Shuttle?.self, arguments: ["id": .variable("shuttleId")]),
      ] }

      public var shuttle: Shuttle? { __data["shuttle"] }

      /// System.Shuttle
      ///
      /// Parent Type: `Shuttle`
      public struct Shuttle: ProjectInterOperations.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Shuttle }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("etas", [Eta]?.self),
        ] }

        public var name: String { __data["name"] }
        public var etas: [Eta]? { __data["etas"] }

        /// System.Shuttle.Eta
        ///
        /// Parent Type: `ETA`
        public struct Eta: ProjectInterOperations.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.ETA }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("stop", Stop?.self),
            .field("secondsRemaining", Double.self),
          ] }

          public var stop: Stop? { __data["stop"] }
          public var secondsRemaining: Double { __data["secondsRemaining"] }

          /// System.Shuttle.Eta.Stop
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
            ] }

            public var name: String { __data["name"] }
            public var id: ProjectInterOperations.ID { __data["id"] }
          }
        }
      }
    }
  }
}
