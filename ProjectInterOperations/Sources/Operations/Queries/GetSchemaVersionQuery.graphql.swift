// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetSchemaVersionQuery: GraphQLQuery {
  public static let operationName: String = "GetSchemaVersion"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetSchemaVersion { schemaMinVersion schemaCurrentVersion }"#
    ))

  public init() {}

  nonisolated public struct Data: ProjectInterOperations.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { ProjectInterOperations.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("schemaMinVersion", Int.self),
      .field("schemaCurrentVersion", Int.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GetSchemaVersionQuery.Data.self
    ] }

    public var schemaMinVersion: Int { __data["schemaMinVersion"] }
    public var schemaCurrentVersion: Int { __data["schemaCurrentVersion"] }
  }
}
