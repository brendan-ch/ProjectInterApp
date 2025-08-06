// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetSchemaVersionQuery: GraphQLQuery {
  public static let operationName: String = "GetSchemaVersion"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetSchemaVersion { schemaMinVersion schemaCurrentVersion }"#
    ))

  public init() {}

  public struct Data: ProjectInterOperations.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("schemaMinVersion", Int.self),
      .field("schemaCurrentVersion", Int.self),
    ] }

    public var schemaMinVersion: Int { __data["schemaMinVersion"] }
    public var schemaCurrentVersion: Int { __data["schemaCurrentVersion"] }
  }
}
