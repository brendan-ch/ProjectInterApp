// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct ScheduleNotificationMutation: GraphQLMutation {
  public static let operationName: String = "ScheduleNotification"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation ScheduleNotification($input: NotificationInput!) { scheduleNotification(input: $input) { __typename success message data { __typename deviceId shuttleId stopId } } }"#
    ))

  public var input: NotificationInput

  public init(input: NotificationInput) {
    self.input = input
  }

  @_spi(Unsafe) public var __variables: Variables? { ["input": input] }

  nonisolated public struct Data: ProjectInterOperations.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("scheduleNotification", ScheduleNotification.self, arguments: ["input": .variable("input")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      ScheduleNotificationMutation.Data.self
    ] }

    public var scheduleNotification: ScheduleNotification { __data["scheduleNotification"] }

    /// ScheduleNotification
    ///
    /// Parent Type: `NotificationResponse`
    nonisolated public struct ScheduleNotification: ProjectInterOperations.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.NotificationResponse }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool.self),
        .field("message", String.self),
        .field("data", Data?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        ScheduleNotificationMutation.Data.ScheduleNotification.self
      ] }

      public var success: Bool { __data["success"] }
      public var message: String { __data["message"] }
      public var data: Data? { __data["data"] }

      /// ScheduleNotification.Data
      ///
      /// Parent Type: `Notification`
      nonisolated public struct Data: ProjectInterOperations.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Notification }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("deviceId", ProjectInterOperations.ID.self),
          .field("shuttleId", ProjectInterOperations.ID.self),
          .field("stopId", ProjectInterOperations.ID.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          ScheduleNotificationMutation.Data.ScheduleNotification.Data.self
        ] }

        public var deviceId: ProjectInterOperations.ID { __data["deviceId"] }
        public var shuttleId: ProjectInterOperations.ID { __data["shuttleId"] }
        public var stopId: ProjectInterOperations.ID { __data["stopId"] }
      }
    }
  }
}
