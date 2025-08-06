// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ProjectInterOperations.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ProjectInterOperations.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ProjectInterOperations.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ProjectInterOperations.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Coordinates": return ProjectInterOperations.Objects.Coordinates
    case "ETA": return ProjectInterOperations.Objects.ETA
    case "HistoricalParkingAverageQueryResult": return ProjectInterOperations.Objects.HistoricalParkingAverageQueryResult
    case "Mutation": return ProjectInterOperations.Objects.Mutation
    case "Notification": return ProjectInterOperations.Objects.Notification
    case "NotificationResponse": return ProjectInterOperations.Objects.NotificationResponse
    case "OrderedStop": return ProjectInterOperations.Objects.OrderedStop
    case "ParkingStructure": return ProjectInterOperations.Objects.ParkingStructure
    case "ParkingSystem": return ProjectInterOperations.Objects.ParkingSystem
    case "Query": return ProjectInterOperations.Objects.Query
    case "Route": return ProjectInterOperations.Objects.Route
    case "Shuttle": return ProjectInterOperations.Objects.Shuttle
    case "Stop": return ProjectInterOperations.Objects.Stop
    case "System": return ProjectInterOperations.Objects.System
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
