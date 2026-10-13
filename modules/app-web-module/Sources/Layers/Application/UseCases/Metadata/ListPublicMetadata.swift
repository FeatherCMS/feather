public import FeatherApplication
public import FeatherContracts

public struct ListPublicMetadata: UseCase {
    let query: any QueryExecutor<ReadMetadata>

    public init(query: any QueryExecutor<ReadMetadata>) {
        self.query = query
    }

    public func execute() async throws -> [MetadataList.Item] {
        try await query.run { scope in
            try await scope.metadata.listPublic()
        }
    }
}
