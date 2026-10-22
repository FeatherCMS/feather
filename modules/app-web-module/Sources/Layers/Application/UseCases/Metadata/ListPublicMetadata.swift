public import FeatherApplication
public import FeatherModuleKit
public import WebDomain

public struct ListPublicMetadata: UseCase {
    let query: any QueryExecutor<Metadata.Query.Scope>

    public init(query: any QueryExecutor<Metadata.Query.Scope>) {
        self.query = query
    }

    public func execute() async throws -> [MetadataList.Item] {
        try await query.run { scope in
            try await scope.metadata.listPublic()
        }
    }
}
