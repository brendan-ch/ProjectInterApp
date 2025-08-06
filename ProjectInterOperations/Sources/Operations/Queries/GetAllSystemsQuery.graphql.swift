// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetAllSystemsQuery: GraphQLQuery {
  public static let operationName: String = "GetAllSystems"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetAllSystems { systems { __typename name id } }"#
    ))

  public init() {}

  public struct Data: ProjectInterOperations.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("systems", [System].self),
    ] }

    public var systems: [System] { __data["systems"] }

    /// System
    ///
    /// Parent Type: `System`
    public struct System: ProjectInterOperations.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.System }
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
