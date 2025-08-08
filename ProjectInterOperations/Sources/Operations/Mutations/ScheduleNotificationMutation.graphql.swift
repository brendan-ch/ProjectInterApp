// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ScheduleNotificationMutation: GraphQLMutation {
  public static let operationName: String = "ScheduleNotification"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation ScheduleNotification($input: NotificationInput!) { scheduleNotification(input: $input) { __typename success message data { __typename deviceId shuttleId stopId } } }"#
    ))

  public var input: NotificationInput

  public init(input: NotificationInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ProjectInterOperations.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("scheduleNotification", ScheduleNotification.self, arguments: ["input": .variable("input")]),
    ] }

    public var scheduleNotification: ScheduleNotification { __data["scheduleNotification"] }

    /// ScheduleNotification
    ///
    /// Parent Type: `NotificationResponse`
    public struct ScheduleNotification: ProjectInterOperations.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.NotificationResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool.self),
        .field("message", String.self),
        .field("data", Data?.self),
      ] }

      public var success: Bool { __data["success"] }
      public var message: String { __data["message"] }
      public var data: Data? { __data["data"] }

      /// ScheduleNotification.Data
      ///
      /// Parent Type: `Notification`
      public struct Data: ProjectInterOperations.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Notification }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("deviceId", ProjectInterOperations.ID.self),
          .field("shuttleId", ProjectInterOperations.ID.self),
          .field("stopId", ProjectInterOperations.ID.self),
        ] }

        public var deviceId: ProjectInterOperations.ID { __data["deviceId"] }
        public var shuttleId: ProjectInterOperations.ID { __data["shuttleId"] }
        public var stopId: ProjectInterOperations.ID { __data["stopId"] }
      }
    }
  }
}
