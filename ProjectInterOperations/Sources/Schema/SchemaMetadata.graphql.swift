// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

nonisolated public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ProjectInterOperations.SchemaMetadata {}

nonisolated public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ProjectInterOperations.SchemaMetadata {}

nonisolated public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ProjectInterOperations.SchemaMetadata {}

nonisolated public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ProjectInterOperations.SchemaMetadata {}

nonisolated public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  private static let objectTypeMap: [String: ApolloAPI.Object] = [
    "Coordinates": ProjectInterOperations.Objects.Coordinates,
    "ETA": ProjectInterOperations.Objects.ETA,
    "HistoricalParkingAverageQueryResult": ProjectInterOperations.Objects.HistoricalParkingAverageQueryResult,
    "Mutation": ProjectInterOperations.Objects.Mutation,
    "Notification": ProjectInterOperations.Objects.Notification,
    "NotificationResponse": ProjectInterOperations.Objects.NotificationResponse,
    "OrderedStop": ProjectInterOperations.Objects.OrderedStop,
    "ParkingStructure": ProjectInterOperations.Objects.ParkingStructure,
    "ParkingSystem": ProjectInterOperations.Objects.ParkingSystem,
    "Query": ProjectInterOperations.Objects.Query,
    "Region": ProjectInterOperations.Objects.Region,
    "Route": ProjectInterOperations.Objects.Route,
    "Shuttle": ProjectInterOperations.Objects.Shuttle,
    "Stop": ProjectInterOperations.Objects.Stop,
    "System": ProjectInterOperations.Objects.System
  ]

  @_spi(Execution) public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    objectTypeMap[typename]
  }
}

nonisolated public enum Objects {}
nonisolated public enum Interfaces {}
nonisolated public enum Unions {}
